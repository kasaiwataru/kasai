package com.example.labo.com.example.labo.model;

import com.example.labo.model.IndexRepository;
import com.example.labo.model.LaboRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;

@Service
public class LaboService {
    @Autowired
    private LaboRepository repository;

    public Labo findById(String laboId) {
        return repository.findById(laboId);
    }
    public List<Labo> StudentAll(String laboId){
        try{
            return repository.selectStudent(laboId);
        }catch (DataAccessException e){
            e.printStackTrace();
        }
        return Collections.emptyList();
    }
}
