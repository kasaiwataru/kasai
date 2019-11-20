package com.example.labo;

import com.example.labo.com.example.labo.model.Index;
import com.example.labo.com.example.labo.model.IndexService;
import com.example.labo.com.example.labo.model.Labo;
import com.example.labo.com.example.labo.model.LaboService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class LaboController {
    @Autowired
    private IndexService indexService;
    @Autowired
    private LaboService laboService;

    @RequestMapping("/")
    public String index(Model model){
        var classA = indexService.laboEachClass("A");
        model.addAttribute("classA",classA);
        var classB = indexService.laboEachClass("B");
        model.addAttribute("classB",classB);
        var classC = indexService.laboEachClass("C");
        model.addAttribute("classC",classC);
        return "index";
    }
    @RequestMapping("/{laboId}")
    public String labo(Model model,@PathVariable("laboId") String laboId){
        Labo labo = laboService.findById(laboId);
        model.addAttribute("laboname",labo.getLaboName());
        var students = laboService.StudentAll(laboId);
        model.addAttribute("laboId",laboId);
        model.addAttribute("students",students);
        return "laboview";
    }
    @RequestMapping("/students/{studentId}")
    public String student(Model model,@PathVariable("studentId") String studentId){

        return "student";
    }
}
