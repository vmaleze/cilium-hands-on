package com.ippon.cilium.handson.unit.clients;

import retrofit2.Call;
import retrofit2.http.GET;
import retrofit2.http.Header;
import retrofit2.http.Headers;

public interface Stronghold {

  @Headers("Connection: close")
  @GET("/weapons")
  Call<String> getWeapon(@Header("x-request-sender") String sender);
}
