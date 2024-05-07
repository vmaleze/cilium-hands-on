package com.ippon.cilium.handson.unit.clients;

import com.ippon.cilium.handson.unit.models.Weapon;
import retrofit2.Call;
import retrofit2.http.GET;
import retrofit2.http.Header;

public interface Stronghold {

  @GET("/weapons")
  Call<Weapon> getWeapon(@Header("x-request-sender") String sender);
}
