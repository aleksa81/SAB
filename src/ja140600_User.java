package student;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import operations.UserOperations;

public class ja140600_User implements UserOperations {

    @Override
    public boolean insertUser(String userName, String firstName, String lastName, String password) {

        if (password.length() < 9) {
            return false;
        }
        if (!password.matches(".*[a-zA-Z].*") || !password.matches(".*[0-9].*")) {
            return false;
        }
        if (!Character.isUpperCase(firstName.charAt(0))) {
            return false;
        }
        if (!Character.isUpperCase(lastName.charAt(0))) {
            return false;
        }

        Connection conn = DB.getConnection();
        try (PreparedStatement stmt = conn.prepareStatement("insert into MyUser(Username, Name, Surname, Password, SentPackages) values(?,?,?,?,?)")) {
            stmt.setString(1, userName);
            stmt.setString(2, firstName);
            stmt.setString(3, lastName);
            stmt.setString(4, password);
            stmt.setInt(5, 0);

            if (stmt.executeUpdate() == 1) {
                return true;
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }

        return false;
    }

    @Override
    public int declareAdmin(String username) {

        Connection conn = DB.getConnection();

        try (CallableStatement proc = conn.prepareCall("{? = call PR_Declare_Admin(?)}")) {
            proc.registerOutParameter(1, Types.INTEGER);
            proc.setString(2, username);
            proc.execute();

            return proc.getInt(1);
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }
        
        return -1;
    }

    @Override
    public Integer getSentPackages(String... usernames) {
        Connection conn = DB.getConnection();
        
        StringBuilder builder = new StringBuilder();
        
        for (int i=0;i<usernames.length;i++){
            builder.append("?,");
        }
        
        builder.deleteCharAt(builder.length()-1);
        
        try(PreparedStatement stmt = conn.prepareStatement("select SUM(SentPackages) from MyUser where Username in (" + builder.toString() + ")")){
            for (int i = 0; i < usernames.length; i++) {
                stmt.setString(i + 1, usernames[i]);
            }
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()){
                    Integer ret = rs.getInt(1);
                    if (rs.wasNull()) return null;
                    return ret;
                }
            }
            
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }
        
        return 0;
    }

    @Override
    public int deleteUsers(String... usernames) {
        Connection conn = DB.getConnection();
        
        StringBuilder builder = new StringBuilder();
        
        for (int i=0;i<usernames.length;i++){
            builder.append("?,");
        }
        
        builder.deleteCharAt(builder.length() - 1);
        
        try(PreparedStatement stmt = conn.prepareStatement("delete from MyUser where Username in ("+builder.toString() + ")")){
            for (int i=0;i<usernames.length;i++){
                stmt.setString(i+1, usernames[i]);
            }
            
            return stmt.executeUpdate();
            
            
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }
        
        return 0;
    }

    @Override
    public List<String> getAllUsers() {
        List<String> list = new ArrayList<>();
        
        Connection conn = DB.getConnection();
        
        try(PreparedStatement stmt = conn.prepareCall("select Username from MyUser"); ResultSet rs = stmt.executeQuery()){
            while (rs.next()){
                list.add(rs.getString("Username"));
            }
            
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }
        
        return list;
    }

}
