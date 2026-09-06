package com.tlahtolli.api.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.jdbc.core.JdbcTemplate;

import java.util.List;
import java.util.Map;

@Controller
public class ViewController {

    private final JdbcTemplate jdbcTemplate;

    public ViewController(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @GetMapping("/view")
    public String dbCheck(Model model) {
        List<Map<String, Object>> users = jdbcTemplate.queryForList("SELECT id, username FROM users");
        model.addAttribute("users", users);
        return "index"; // busca templates/index.html
    }
}