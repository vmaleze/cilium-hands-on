package com.ippon.cilium.handson.stronghold.controllers;

import com.ippon.cilium.handson.stronghold.models.Weapon;
import java.util.Objects;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class StrongholdController {

  @GetMapping("weapons")
  public Weapon getWeapon(@RequestHeader(value = "x-request-sender", required = false) String requestSender) {
    if (Objects.equals(requestSender, "human")) {
      System.exit(1);
    }
    return Weapon.randomWeapon();
  }

  @PutMapping("new-king")
  public String newKing(@RequestParam String kingName) {
    return "Long live king " + kingName;
  }

}
