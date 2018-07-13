package student;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import operations.CourierRequestOperation;

public class ja140600_CourierRequest implements CourierRequestOperation {

    @Override
    public boolean insertCourierRequest(String username, String licenceNumber) {
        
        Connection conn = DB.getConnection();
        
        // TODO ako je vec kurir nece uspeti
        
        try (PreparedStatement stmt = conn.prepareStatement(
                "if not exists (select * from Courier where Username =?) "
                + "insert into Request(Username, LicenceNumber) values (?,?)"
        )) {
            stmt.setString(1, username);
            stmt.setString(2, username);
            stmt.setString(3, licenceNumber);

            if (stmt.executeUpdate() == 1) {
                return true;
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }

        return false;
    }

    @Override
    public boolean deleteCourierRequest(String username) {

        Connection conn = DB.getConnection();
        try (PreparedStatement stmt = conn.prepareStatement("delete from Request where Username = ?")) {
            stmt.setString(1, username);

            if (stmt.executeUpdate() == 1) {
                return true;
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }

        return false;
    }

    @Override
    public boolean changeVehicleInCourierRequest(String username, String licenceNumber) {

        Connection conn = DB.getConnection();
        try (PreparedStatement stmt = conn.prepareStatement("update Request set LicenceNumber = ? where Username = ?")) {
            stmt.setString(1, licenceNumber);
            stmt.setString(2, username);

            if (stmt.executeUpdate() == 1) {
                return true;
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }

        return false;
    }

    @Override
    public List<String> getAllCourierRequests() {
        List<String> list = new ArrayList<>();

        Connection conn = DB.getConnection();

        try (PreparedStatement stmt = conn.prepareStatement("select Username from Request"); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(rs.getString("Username"));
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }

        return list;
    }

    @Override
    public boolean grantRequest(String username) {

        Connection conn = DB.getConnection();

        try (CallableStatement proc = conn.prepareCall("{ ? = call PR_Grant_Request(?) }")) {
            proc.registerOutParameter(1, Types.INTEGER);
            proc.setString(2, username);
            proc.execute();
            if (proc.getInt(1) == 1) {
                return true;
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }

        return false;
    }

}
