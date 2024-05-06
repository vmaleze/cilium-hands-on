package com.ippon.cilium.handson.unit.configurations;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "application", ignoreUnknownFields = false)
public class ApplicationProperties {

  private String strongholdUrl;

  public String getStrongholdUrl() {
    return strongholdUrl;
  }

  public ApplicationProperties setStrongholdUrl(String strongholdUrl) {
    this.strongholdUrl = strongholdUrl;
    return this;
  }
}
