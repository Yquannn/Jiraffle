package com.pms.ads.Controllers;

import org.springframework.web.bind.annotation.RestController;

import com.pms.common.entities.Message;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

@RestController
public class AdsController {

    @RequestMapping("/hello")
    public Message Hello() {
        return new Message("healr");
    }
}
