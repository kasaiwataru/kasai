package com.example.labo.com.example.labo.model;

public class Index {
    private String laboName;
    private String laboClass;
    private String about;
    private String img;
    private String laboId;

    public Index(){
        this.laboName="";
        this.laboClass="";
        this.about="";
        this.img="";
        this.laboId="";
    }

    public String getAbout() {
        return about;
    }
    public String getLaboClass() {
        return laboClass;
    }
    public String getLaboName() {
        return laboName;
    }
    public String getImg() { return img; }
    public String getLaboId() {
        return laboId;
    }

    public void setAbout(String about) {
        this.about = about;
    }
    public void setLaboClass(String laboClass) {
        this.laboClass = laboClass;
    }
    public void setLaboName(String laboName) {
        this.laboName = laboName;
    }
    public void setImg(String img) { this.img = "/images/prof/" +img; }
    public void setLaboId(String labolink) {
        this.laboId = labolink;
    }
}
