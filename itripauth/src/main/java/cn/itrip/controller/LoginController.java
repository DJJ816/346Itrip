package cn.itrip.controller;

import cn.itrip.biz.SMSHelp;
import cn.itrip.biz.TokenBiz;
import cn.itrip.dao.itripHotel.ItripHotelMapper;
import cn.itrip.dao.itripUser.ItripUserMapper;
import cn.itrip.pojo.ItripHotel;
import cn.itrip.pojo.ItripUser;
import cn.itrip.common.*;
import cn.itrip.pojo.ItripUserVO;
import com.alibaba.fastjson.JSONArray;

import io.swagger.annotations.*;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.Calendar;

@Controller
@Api(value = "itripauth",description = "itripauth模块")
public class LoginController {
    //用于与用户业务类有关的映射接口
    @Resource
    ItripUserMapper itripUserMapper;
    //用于返回用户令牌的biz业务层
    @Resource
    TokenBiz tokenBiz;
    //Redis 数据存储Api
    @Resource
    JredisApi jredisApi;
    @RequestMapping(value = "/api/dologin",method = RequestMethod.POST)
    @ApiImplicitParams({
            @ApiImplicitParam(paramType="form",required=true,value="用户名",name="name",defaultValue="itrip@163.com"),
            @ApiImplicitParam(paramType="form",required=true,value="密码",name="password",defaultValue="123456"),
    })
    @ResponseBody
    public Dto loginController(String name, String password, HttpServletRequest request) throws Exception {
        //MD5加密密码
        String md5 = MD5.getMd5(password, 32);
        System.out.println(md5);
        //查询验证用户信息
        ItripUser itripUser = itripUserMapper.doLogin(name, md5);
        //判断是否为空，不为空则进行下一步操作，为空则登陆失败
        if(null!=itripUser){
            /**
             * 若不为空，则按照往常逻辑要把用户的信息存入session，但在分布式集群框架下，各个服务器之间session
             * 并不能共享，因此需要借助Redis进行共享session:
             * 具体做法为：
             */
            //令牌格式通过使用http请求头中的User-Agent（通过request.getHeader(String s)获取）、用户实体类、时间戳等生成
            String token = tokenBiz.generateToken(request.getHeader("User-Agent"), itripUser);
            //令牌对应的值为用户实体的JSON格式的字符串
            String value = JSONArray.toJSONString(itripUser);
            //以上步骤进行完成后，首先判断Redis中是否存在该令牌，若不存在则添加，存在则不添加，防止重复
            System.out.println(token);
            if(null==jredisApi.getRedis(token)) {
                //将用户令牌，对应的值和过期时间存入Redis
                jredisApi.SetRedis(token, value, 60 * 60 * 2);
                System.out.println("1111");
            }
            //以上程序进行完，将令牌，当前时间，过期时间通过ItripTokenVO类打包传到前端用户，以便之后的操作进行时间比对，从而完成session验证
            ItripTokenVO itripTokenVO=new ItripTokenVO(token,Calendar.getInstance().getTimeInMillis()+60*60*2,Calendar.getInstance().getTimeInMillis());
            return DtoUtil.returnDataSuccess(itripTokenVO);
        }
        return DtoUtil.returnDataSuccess("登录失败！");
    }

    //用户电话注册（@RequestBody是由于springmvc版本的问题，此版本不加会映射不过来)
    @RequestMapping(value = "/api/registerbyphone",produces = {"application/json;charset=UTF-8"},method = RequestMethod.POST)

    @ResponseBody

    public Dto registerController(@RequestBody @ApiParam(name="用户对象Vo",value="传入json格式",required=true) ItripUserVO itripUserVO, HttpServletRequest request) throws Exception {
        //将各个参数赋予 ItripUser的各个属性
        ItripUser itripUser = new ItripUser();
        itripUser.setUserCode(itripUserVO.getUserCode());
        itripUser.setUserName(itripUserVO.getUserName());
        itripUser.setUserPassword(MD5.getMd5(itripUserVO.getUserPassword(),32));
        //用户激活状态默认为0，通过手机短信验证激活
        itripUser.setFlatID(0l);
        //先查询该手机是否注册过账号
        ItripUser itripUser1 = itripUserMapper.registerSelect(itripUserVO.getUserCode());
        System.out.println(itripUser1+"");
       //没注册过
        if(null==itripUser1){
            //用户注册
            int integer = itripUserMapper.insertItripUser(itripUser);
            //数据库插入成功
            if(integer>0){
                //生成手机短信随机数四位
                int codenum = (int) (Math.random() * 9000 + 1000);
                System.out.println(codenum);
                //容联云通讯发送短信（参数：用户手机号，随机数）
                //SMSHelp.sentphone(itripUserVO.getUserCode(),codenum+"");
               //将手机和随机数存入REDIS缓存以便激活验证
                jredisApi.SetRedis(itripUserVO.getUserCode(),codenum+"",60*5);
                return DtoUtil.returnSuccess("注册成功！");
            }else {
                //数据库插入失败
                return DtoUtil.returnFail("注册失败！","2000");
            }
        }else {
            //重复注册失败
            return DtoUtil.returnFail("注册失败，该电话已注册！","1000");
        }
    }
    //验证手机激活账号
    @RequestMapping(value = "/api/validatephone",produces = {"application/json;charset=UTF-8"},method = RequestMethod.PUT)
    @ResponseBody
    public Dto validatephoneController(String user,String code) throws Exception {
       //取出Redis中手机号对应的验证码
        String code1 = jredisApi.getRedis(user);
        //验证码验证
        System.out.println(code+"-"+code1+"-"+user);
        if(code1.equals(code)){
            //验证成功，修改激活状态
             int i = itripUserMapper.activeUserCode(user);
             //激活成功与否判断
             if(i>0){
                 return DtoUtil.returnDataSuccess("账户激活成功！");
             }else{
                 return DtoUtil.returnFail("账户激活失败！","3000");
             }
        }else{
            //激活码验证失败
            return DtoUtil.returnFail("账户激活失败！","3000");
        }
    }
    //账号再次激活，包含邮箱验证激活
    @RequestMapping(value = "/api/activate",produces = {"application/json;charset=UTF-8"},method = RequestMethod.PUT)
    @ResponseBody
    public Dto activateController(String user,String code) throws Exception {
        String code1 = jredisApi.getRedis(user);
        System.out.println(code+"-"+code1+"-"+user);

        if(code1.equals(code)){
            int i = itripUserMapper.activeUserCode(user);
            if(i>0){
                return DtoUtil.returnSuccess("账户激活成功！");
            }else{
                return DtoUtil.returnFail("账户激活失败！","3000");
            }
        }else{
            return DtoUtil.returnFail("账户激活失败！","3000");
        }
    }

    @Resource
    ItripHotelMapper itripHotelMapper;
    @RequestMapping("/list")
    @ResponseBody
    public ItripHotel getHotelList(){
        try {
            return itripHotelMapper.getItripHotelById(new Long("1"));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

}
