
package student;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;


public class DB {
    
    static private String url = "jdbc:sqlserver://localhost\\DESKTOP-GG78FUE:1433;databaseName=Transport;integratedSecurity=true";
    
    static private Connection connection = null;
    
    public static Connection getConnection(){
        if (connection == null){
            try {
                connection = DriverManager.getConnection(url);
            } catch (SQLException ex) {
                Logger.getLogger(DB.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return connection;
    }
    
}
