package com.tlahtolli.api.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ViewController {

    /** Sirve el index.html del SPA para rutas no-API. */
    @GetMapping("/view")
    public String index() {
        return "index";
    }
}
