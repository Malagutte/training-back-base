package com.backbase.training.controller;

import com.backbase.buildingblocks.presentation.errors.BadRequestException;
import com.backbase.buildingblocks.presentation.errors.InternalServerErrorException;
import com.backbase.fee.rest.spec.serviceapi.v1.exchange.ExchangeApi;
import com.backbase.fee.rest.spec.v1.exchange.FeeGetResponseBody;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@RequestMapping("/service-api/v1/exchange")
@RestController
// 1
public class FeeController implements ExchangeApi {

    // 2
    @Override
    public FeeGetResponseBody getFee(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse) throws BadRequestException, InternalServerErrorException {
        // 3
        return new FeeGetResponseBody().withFee(1.1234);
    }
}