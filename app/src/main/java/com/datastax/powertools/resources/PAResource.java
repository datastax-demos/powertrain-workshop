package com.datastax.powertools.resources;

import com.codahale.metrics.annotation.Timed;
import com.datastax.driver.core.PreparedStatement;
import com.datastax.driver.dse.DseSession;
import com.datastax.driver.mapping.MappingManager;
import com.datastax.driver.mapping.Result;
import com.datastax.driver.mapping.annotations.Accessor;
import com.datastax.driver.mapping.annotations.Column;
import com.datastax.driver.mapping.annotations.Query;
import com.datastax.driver.mapping.annotations.Table;
import com.datastax.powertools.PowertrainConfig;
import com.datastax.powertools.managed.Dse;
import com.fasterxml.jackson.annotation.JsonProperty;
import java.io.Serializable;
import java.util.Date;
import java.util.List;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;

/**
 * Created by sebastianestevez on 6/1/18.
 */
@Path("/v0/powertrain")
public class PAResource {
    private final Dse dse;
    private final DseSession session;
    private final PowertrainConfig config;

    private static final String ALL_EVENTS = "select * from vehicle_tracking_app.vehicle_stats;";
    private PreparedStatement allEvents;

    @Accessor
    public interface VehicleEventAccessor {
        @Query(ALL_EVENTS)
        Result<VehicleEvent> getAll();
    }

    @Table(keyspace = "vehicle_tracking_app", name = "vehicle_stats",
            readConsistency = "QUORUM",
            writeConsistency = "QUORUM")
    public static class VehicleEvent implements Serializable {

        @Column(name = "vehicle_id")
        @JsonProperty
        private String vehicleId;

        @JsonProperty
        @Column(name = "time_period")
        private Date timePeriod;

        @JsonProperty
        @Column(name = "collect_time")
        private Date collect_time;

        @JsonProperty
        private double acceleration;

        @JsonProperty
        @Column(name = "elapsed_time")
        private int elapsedTime;

        @JsonProperty
        private String elevation;

        @JsonProperty
        @Column(name = "fuel_level")
        private float fuelLevel;

        @JsonProperty
        @Column(name = "lat_long")
        private String lat_long;

        @JsonProperty
        private float mileage;

        @JsonProperty
        private double speed;
    }

    public PAResource(Dse dse, PowertrainConfig config) {
        this.dse = dse;
        this.config = config;
        this.session = dse.getSession();

        allEvents = session.prepare(ALL_EVENTS);
    }

    @GET
    @Timed
    @Path("/allEvents")
    @Produces(MediaType.APPLICATION_JSON)
    public List<VehicleEvent> getAllEvents() {
        try {
            String query =  ALL_EVENTS;

            MappingManager manager = new MappingManager(session);

            VehicleEventAccessor veMapper= manager.createAccessor(VehicleEventAccessor.class);

            Result<VehicleEvent> result = veMapper.getAll();

            List<VehicleEvent> output = result.all();

            return output;

        }catch (Exception e){
            System.out.println(e.toString());
            e.printStackTrace();
            return null;
        }
    }
}
