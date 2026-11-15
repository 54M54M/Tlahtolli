package com.tlahtolli.api.controller;

import java.security.Principal;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.tlahtolli.api.repository.UserRepository;
import com.tlahtolli.api.security.TokenService;

@Controller
public class ViewController {

    /** Vigencia del token que usa el monitor para llamar a la API (igual a la sesión). */
    private static final long MONITOR_TOKEN_SECONDS = 60 * 60;

    private final UserRepository userRepo;
    private final TokenService tokenService;

    public ViewController(UserRepository userRepo, TokenService tokenService) {
        this.userRepo = userRepo;
        this.tokenService = tokenService;
    }

    @GetMapping("/monitor")
    public String monitor(Principal principal, Model model) {
        var user = userRepo.findByUsername(principal.getName()).orElseThrow();
        var token = tokenService.issue(user, MONITOR_TOKEN_SECONDS);
        model.addAttribute("apiToken", token.token());
        model.addAttribute("adminUser", user.getUsername());
        return "index";
    }

    @GetMapping("/monitor/login")
    public String login() {
        return "monitor-login";
    }
}
