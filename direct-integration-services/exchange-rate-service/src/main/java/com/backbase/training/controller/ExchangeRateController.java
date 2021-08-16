package com.backbase.training.controller;

import com.backbase.buildingblocks.presentation.errors.BadRequestException;
import com.backbase.buildingblocks.presentation.errors.InternalServerErrorException;
import com.backbase.exchangeratespecification.rest.spec.v1.exchange.ExchangeApi;
import com.backbase.exchangeratespecification.rest.spec.v1.exchange.FeeGetResponseBody;
import com.backbase.exchangeratespecification.rest.spec.v1.exchange.RatesGetResponseBody;
import com.backbase.fee.listener.client.v1.exchange.FeeExchangeClient;
import com.backbase.training.service.ExchangeRateService;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDate;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import lombok.RequiredArgsConstructor;

@RequestMapping("/client-api/v1/exchange")
@RestController
@RequiredArgsConstructor
public class ExchangeRateController implements ExchangeApi {

    private final ExchangeRateService exchangeRateService;

    // 1
    private final FeeExchangeClient feeClient;

    @Override
    public List<RatesGetResponseBody> getRates(
            @RequestParam(value = "source", required = true) String source,
            @RequestParam(value = "target", required = true) String target,
            @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
            @RequestParam(value = "from") LocalDate from,
            @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
            @RequestParam(value = "to") LocalDate to,
            HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse) throws BadRequestException, InternalServerErrorException {
        return exchangeRateService.retrieveRates(source, target, from, to);
    }

    @Override
    // 2
    public FeeGetResponseBody getFee(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse) throws BadRequestException, InternalServerErrorException {
        // 3
        Double fee = feeClient.getFee().getBody().getFee();
        return new FeeGetResponseBody().withFee(fee);
    }

}