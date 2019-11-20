package com.example.labo.com.example.labo.model;

import com.example.labo.model.IndexRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;

@Service
public class IndexService {
    @Autowired
    private IndexRepository repository;

    public List<Index> laboEachClass(String laboClass){
        try{
            return repository.select(laboClass);
        }catch (DataAccessException e){
            e.printStackTrace();
        }
        return Collections.emptyList();
    }
}
