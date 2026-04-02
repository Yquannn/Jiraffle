package com.yourcompany.ads;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/ads")
public class AdsController {

    @GetMapping("/hello")
    public String hello() {
        return "Hello from Ads Service!";
    }

}