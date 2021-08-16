package com.backbase.training.service;

import com.backbase.exchangeratespecification.rest.spec.v1.exchange.RatesGetResponseBody;

import org.apache.commons.lang3.ObjectUtils;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class ExchangeRateService {

    private final RestTemplate restTemplate;

    // 1
    @Value("${transferwise.url.rates}")
    private String transferwiseRatesUrl;

    // 2
    @Value("${transferwise.api-key}")
    private String transferwiseApiKey;

    public ExchangeRateService(@Qualifier(value = "customRestTemplate") RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    // 3
    public List<RatesGetResponseBody> retrieveRates(String source, String target, LocalDate from, LocalDate to){
        to = ObjectUtils.defaultIfNull(to, LocalDate.now());
        from = ObjectUtils.defaultIfNull(from, LocalDate.now());

        LocalDateTime fromFormatted = from.atStartOfDay();
        LocalDateTime toFormatted = to.atTime(LocalTime.MAX);

        //4
        return restTemplate.exchange(transferwiseRatesUrl, HttpMethod.GET, generateAuthHeaders(),
                new ParameterizedTypeReference<List<RatesGetResponseBody>>(){}, source, target, fromFormatted, toFormatted).getBody();
    }

    private HttpEntity generateAuthHeaders() {
        HttpHeaders httpHeaders = new HttpHeaders();
        httpHeaders.setBearerAuth(transferwiseApiKey);
        return new HttpEntity(httpHeaders);
    }
}