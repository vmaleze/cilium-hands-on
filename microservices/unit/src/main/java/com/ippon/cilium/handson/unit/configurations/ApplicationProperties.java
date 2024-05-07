package com.ippon.cilium.handson.unit.configurations;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "application", ignoreUnknownFields = false)
public class ApplicationProperties {

  private String strongholdUrl;
  private String unit;

  public String getStrongholdUrl() {
    return strongholdUrl;
  }

  public ApplicationProperties setStrongholdUrl(String strongholdUrl) {
    this.strongholdUrl = strongholdUrl;
    return this;
  }

  public String getUnit() {
    return unit;
  }

  public ApplicationProperties setUnit(String unit) {
    this.unit = unit;
    return this;
  }
}
