package com.backbase.training;

import org.springframework.boot.web.client.RestTemplateBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;

@Configuration
public class Config {

    @Bean(name = "customRestTemplate")
    public RestTemplate restTemplate(){
        return new RestTemplateBuilder().build();
    }

}