package com.syi.project.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.SimpleMongoClientDatabaseFactory;
import org.springframework.data.mongodb.repository.config.EnableMongoRepositories;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;

@Configuration
@EnableMongoRepositories(basePackages = "com.syi.project.mapper.chat")
public class MongoDBConfig {
	private static final String CONNECTION_STRING = "mongodb://songyeoin:songyeoin@localhost:27017/chat?authSource=admin";

	
	@Bean
    public MongoClient mongoClient() {
        return MongoClients.create(CONNECTION_STRING);
    }

    @Bean
    public MongoTemplate mongoTemplate() {
        // MongoDB 데이터베이스 이름을 설정
        return new MongoTemplate(new SimpleMongoClientDatabaseFactory(mongoClient(), "chat"));
    }
    /*
     * @Bean public MongoClient mongoClient() { return
     * MongoClients.create(CONNECTION_STRING); }
     * 
     * @Bean public MongoTemplate mongoTemplate() { return new
     * MongoTemplate(mongoClient(), "chat"); }
     */
}
