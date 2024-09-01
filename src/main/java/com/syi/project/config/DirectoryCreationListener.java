package com.syi.project.config;

import java.io.File;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

public class DirectoryCreationListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        String tempDirPath = "C:\\upload\\temp";
        File tempDir = new File(tempDirPath);
        if (!tempDir.exists()) {
            if (tempDir.mkdirs()) {
                System.out.println("Temporary directory created: " + tempDirPath);
            } else {
                System.out.println("Failed to create temporary directory: " + tempDirPath);
            }
        }
    }
}
