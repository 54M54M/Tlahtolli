package com.tlahtolli.api;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class tlahtolli {

	public static void main(String[] args) {
		SpringApplication.run(tlahtolli.class, args);
	}

}

/*

CONTENT:
--> LEVELS
	--> UNITS [ obtiene data directo de EXERCISES ]
		--> LESSONS [ tabla huerfana ]
			--> EXERCISES

 */