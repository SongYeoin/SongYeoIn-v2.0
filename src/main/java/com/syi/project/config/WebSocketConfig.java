package com.syi.project.config;

import javax.servlet.http.HttpSession;
import javax.websocket.HandshakeResponse;
import javax.websocket.server.HandshakeRequest;
import javax.websocket.server.ServerEndpointConfig;
import javax.websocket.server.ServerEndpointConfig.Configurator;

import org.springframework.context.annotation.Configuration;

import com.syi.project.service.chat.MessageService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Configuration
public class WebSocketConfig extends Configurator {

    @Override
    public void modifyHandshake(ServerEndpointConfig config, HandshakeRequest request, HandshakeResponse response) {
        // HTTP 세션에서 사용자 정보를 가져옵니다.
        HttpSession httpSession = (HttpSession) request.getHttpSession();
        if (httpSession != null) {
            config.getUserProperties().put("loginMember", httpSession.getAttribute("loginMember"));
        }

        // SpringContext를 통해 messageService 빈을 가져옴
        MessageService messageService = SpringContext.getBean(MessageService.class);
        config.getUserProperties().put("messageService", messageService);
        
    }
}
