/**
 * Copyright © 2024, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Hashtable;
import java.util.Properties;

import javax.naming.Context;
import javax.naming.NamingException;
import javax.naming.directory.DirContext;
import javax.naming.directory.InitialDirContext;

class TestLDAP {

    /**
     * This is a minimalistic class for connecting to an LDAP server
     * and authenticating using a username and password.  It is used
     * to verify that the authentication works and to debug issues
     * if necessary.
     */
    public static void main(String[] args) {
        // Connect to the LDAP server and authenticate the user with the password provided
        try {
            // Load the LDAP properties from a file 
            File propfile = new File("ldap.properties");
            if (!propfile.exists()) {
                System.out.println("File not found: ldap.properties");
                System.exit(1);
            }
            Properties props = new Properties();
            props.load(new FileInputStream(propfile));
            String server = props.getProperty("url");
            String username = props.getProperty("username");
            String password = props.getProperty("password");

            System.out.println("Server:   " + server);
            System.out.println("Username: " + username);

            // Authenticate against the LDAP server using the property file values 
            Hashtable<String,String> env = new Hashtable <String,String>();
            env.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
            env.put(Context.SECURITY_AUTHENTICATION, "simple");
            env.put(Context.SECURITY_PRINCIPAL, username);
            env.put(Context.SECURITY_CREDENTIALS, password);
            env.put(Context.PROVIDER_URL, server);
            DirContext ctx = new InitialDirContext(env);
            System.out.println("Successfully authenticated user.");
        } catch (IOException ex) {
            System.out.println("Failed to load properties file: " + ex.getMessage());
        } catch (NamingException ex) {
            System.out.println("Failed to authenticate user: " + ex.getMessage());
        }
    }

}
