package com.example.labo.com.example.labo.model;

public class Labo {
    private String laboName;
    private String laboId;
    private String studentId;
    private String name;

    public Labo(){
        this.laboName="";
        this.laboId="";
        this.studentId="";
        this.name="";
    }

    public String getLaboName() {
        return laboName;
    }
    public String getLaboId() {
        return laboId;
    }
    public String getStudentId() {
        return studentId;
    }
    public String getName() {
        return name;
    }

    public void setLaboName(String laboName) {
        this.laboName = laboName;
    }
    public void setLaboId(String laboId) {
        this.laboId = laboId;
    }
    public void setStudentId(String studentId) {
        this.studentId = studentId;
    }
    public void setName(String name) {
        this.name = name;
    }
}
