package cn.itrip.controller;



import cn.itrip.common.Dto;
import cn.itrip.common.DtoUtil;
import cn.itrip.dao.itripAreaDic.ItripAreaDicMapper;
import cn.itrip.dao.itripLabelDic.ItripLabelDicMapper;
import cn.itrip.pojo.ItripAreaDic;
import cn.itrip.pojo.ItripLabelDic;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;


import javax.annotation.Resource;
import java.util.List;

@Controller
public class HotelController {
    @Resource
    ItripAreaDicMapper itripAreaDicMapper;
    @Resource
    ItripLabelDicMapper itripLabelDicMapper;
    //搜索国内外热门区域，采用restful风格，参数为国内国外编号
    @RequestMapping("/api/hotel/queryhotcity/{type}")
    @ResponseBody
    public Dto queryHotCity(@PathVariable int type ) throws Exception {
        List<ItripAreaDic> hotCityByIshot = itripAreaDicMapper.getHotCityByIshot(type);
        if(null!=hotCityByIshot&&hotCityByIshot.size()!=0) {
            return DtoUtil.returnDataSuccess(hotCityByIshot);
        }else{
            return  DtoUtil.returnFail("系统异常，获取失败！","10202");
        }


    }
    //搜索酒店特色标签，parentId为6
    @RequestMapping("api/hotel/queryhotelfeature")
    @ResponseBody
    public Dto queryHotelFeature() throws Exception{
        List<ItripLabelDic> itripLabelDic = itripLabelDicMapper.getItripLabelDic();
        if(null!=itripLabelDic&&itripLabelDic.size()!=0) {
            return DtoUtil.returnDataSuccess(itripLabelDic);
        }else{
            return  DtoUtil.returnFail("系统异常，获取失败！","10205");
        }

    }


}
