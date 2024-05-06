package com.ippon.cilium.handson.unit.configurations;

import com.ippon.cilium.handson.unit.clients.Stronghold;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import retrofit2.Retrofit;
import retrofit2.converter.jackson.JacksonConverterFactory;

@Configuration
public class ClientConfiguration {

  private final ApplicationProperties applicationProperties;

  public ClientConfiguration(ApplicationProperties applicationProperties) {
    this.applicationProperties = applicationProperties;
  }

  @Bean(name = "stronghold")
  public Stronghold stronghold() {
    return new Retrofit.Builder()
        .baseUrl(this.applicationProperties.getStrongholdUrl())
        .addConverterFactory(JacksonConverterFactory.create())
        .build()
        .create(Stronghold.class);
  }
}
