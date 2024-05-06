package com.ippon.cilium.handson.unit.controllers;

import com.ippon.cilium.handson.unit.clients.Stronghold;
import java.io.IOException;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class UnitController {

  private final Stronghold stronghold;

  public UnitController(Stronghold stronghold) {
    this.stronghold = stronghold;
  }

  @GetMapping("/fetch-weapon")
  public String fetchWeapon() throws IOException {
    final var response = stronghold.getWeapon().execute();
    return "Ready for battle with my " + response.body();
  }
}
