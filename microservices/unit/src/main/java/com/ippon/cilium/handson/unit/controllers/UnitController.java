package com.ippon.cilium.handson.unit.controllers;

import com.ippon.cilium.handson.unit.clients.Stronghold;
import com.ippon.cilium.handson.unit.configurations.ApplicationProperties;
import java.io.IOException;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class UnitController {

  private final Stronghold stronghold;
  private final ApplicationProperties applicationProperties;

  public UnitController(Stronghold stronghold, ApplicationProperties applicationProperties) {
    this.stronghold = stronghold;
    this.applicationProperties = applicationProperties;
  }

  @GetMapping("/fetch-weapon")
  public String fetchWeapon() throws IOException {
    final var response = stronghold.getWeapon(applicationProperties.getUnit()).execute();
    return "Ready for battle with my " + response.body();
  }
}
