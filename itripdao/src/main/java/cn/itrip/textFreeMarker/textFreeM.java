package cn.itrip.textFreeMarker;

import cn.itrip.pojo.ItripHotel;
import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class textFreeM {
    public static void main(String[] args) throws IOException, TemplateException {
        Map map=new HashMap();
        List list=new ArrayList<ItripHotel>();
        for (int i=0;i<10;i++){
            ItripHotel itripHotel = new ItripHotel();
            itripHotel.setHotelName("骚亮酒店"+i+"号");
            list.add(itripHotel);
        }
        map.put("hotels",list);
        Configuration configuration=new Configuration();
        configuration.setDefaultEncoding("UTF-8");
        configuration.setDirectoryForTemplateLoading(new File("D:\\ideaproject\\itripbackend\\itripdao\\src\\main\\resources"));
        Template template = configuration.getTemplate("FreeMarkerDemo1.flt");
        template.process(map,new FileWriter("D:\\ideaproject\\itripbackend\\itripdao\\src\\main\\resources\\FreeMarkerTestFile\\hotel.html"));
    }
}
