package com.baklawati.backend.controller;

import com.baklawati.backend.models.User;
import com.baklawati.backend.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@RestController
@RequestMapping("/api/users")
public class UserController {

    @Autowired
    private UserRepository userRepository;

    @PostMapping("/register")
    public User register(@RequestBody User user) {
        return userRepository.save(user);
    }

    @PostMapping("/login")
    public String login(@RequestBody User loginData) {
        Optional<User> userOpt = userRepository.findByEmail(loginData.getEmail());

        if (userOpt.isPresent()) {
            User user = userOpt.get();
            if (user.getPassword().equals(loginData.getPassword())) {
                return "Login successful";
            }
        }
        return "Invalid email or password";
    }

    @GetMapping("/{id}")
    public Optional<User> getUser(@PathVariable Long id) {
        return userRepository.findById(id);
    }
}
