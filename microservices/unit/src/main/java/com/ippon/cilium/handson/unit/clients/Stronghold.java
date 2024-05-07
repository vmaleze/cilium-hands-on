package com.ippon.cilium.handson.unit.clients;

import retrofit2.Call;
import retrofit2.http.GET;
import retrofit2.http.Header;

public interface Stronghold {

  @GET("/weapons")
  Call<String> getWeapon(@Header("x-request-sender") String sender);
}
