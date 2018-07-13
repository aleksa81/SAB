package student;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import operations.CourierOperations;

public class ja140600_Courier implements CourierOperations {

    public static Integer getCourierStatus(String username) {
        Integer ret = null;

        Connection conn = DB.getConnection();

        try (PreparedStatement stmt = conn.prepareStatement("select Status from Courier where Username = ?")) {
            stmt.setString(1, username);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    ret = rs.getInt("Status");
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }

        return ret;
    }

    public static boolean setCourierStatus(String username, Integer status) {

        Connection conn = DB.getConnection();

        try (PreparedStatement stmt = conn.prepareStatement("update Courier set Status = ? where Username = ?")) {
            stmt.setInt(1, status);
            stmt.setString(2, username);
            if (stmt.executeUpdate() == 1) {
                return true;
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }

        return false;
    }

    public static boolean setCourierProfit(String username, BigDecimal profit) {

        Connection conn = DB.getConnection();

        try (PreparedStatement stmt = conn.prepareStatement("update Courier set Profit = ? where Username = ?")) {
            stmt.setDouble(1, profit.doubleValue());
            stmt.setString(2, username);
            if (stmt.executeUpdate() == 1) {
                return true;
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }

        return false;
    }
    
    public static boolean setCourierDeliveredPackages(String username, int deliveredPackages) {

        Connection conn = DB.getConnection();

        try (PreparedStatement stmt = conn.prepareStatement("update Courier set DeliveredPackages = ? where Username = ?")) {
            stmt.setInt(1, deliveredPackages);
            stmt.setString(2, username);
            if (stmt.executeUpdate() == 1) {
                return true;
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }

        return false;
    }
    
    public static Integer getCourierDeliveredPackages(String username) {
        Integer ret = null;

        Connection conn = DB.getConnection();

        try (PreparedStatement stmt = conn.prepareStatement("select DeliveredPackages from Courier where Username = ?")) {
            stmt.setString(1, username);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    ret = rs.getInt("DeliveredPackages");
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }

        return ret;
    }

    public static BigDecimal getCourierProfit(String username) {
        BigDecimal ret = null;

        Connection conn = DB.getConnection();

        try (PreparedStatement stmt = conn.prepareStatement("select Profit from Courier where Username = ?")) {
            stmt.setString(1, username);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    ret = rs.getBigDecimal("Profit");
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }

        return ret;
    }

    public static BigDecimal getCourierFuelConsumption(String username) {
        BigDecimal ret = null;

        Connection conn = DB.getConnection();

        String query = "select v.FuelEfficiency from Vehicle v inner join Drives d on d.LicenceNumber = v.Licencenumber and d.Username = ?";

        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, username);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    ret = rs.getBigDecimal(1);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }

        return ret;
    }

    public static BigDecimal getCourierFuelPrice(String username) {
        BigDecimal ret = null;

        Connection conn = DB.getConnection();

        String query = "select f.Price from Vehicle v "
                + "inner join Drives d on d.LicenceNumber = v.Licencenumber and d.Username = ? "
                + "inner join Fuel f on f.IdFuel = v.IdFuel";

        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, username);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    ret = rs.getBigDecimal(1);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }

        return ret;
    }
    
    public static boolean existsCourier(String username){
        Connection conn = DB.getConnection();
        try (PreparedStatement stmt = conn.prepareStatement("select Username from Courier where Username = ?")) {
            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    return true;
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }
        return false;   
    }

    @Override
    public boolean insertCourier(String username, String licenceNumber) {
        ja140600_CourierRequest cr = new ja140600_CourierRequest();

        if (!cr.insertCourierRequest(username, licenceNumber)) {
            if (!cr.changeVehicleInCourierRequest(username, licenceNumber)) {
                return false;
            }
        }

        if (!cr.grantRequest(username)) {
            return false;
        }
        return true;

    }

    @Override
    public boolean deleteCourier(String username) {

        Connection conn = DB.getConnection();

        try (PreparedStatement stmt = conn.prepareStatement("delete from Courier where Username = ?")) {
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
    public List<String> getCouriersWithStatus(int status) {
        List<String> list = new ArrayList<>();

        Connection conn = DB.getConnection();
        try (PreparedStatement stmt = conn.prepareStatement("select Username from Courier where Status = ?")) {
            stmt.setInt(1, status);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(rs.getString("Username"));
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }

        return list;
    }

    @Override
    public List<String> getAllCouriers() {
        List<String> list = new ArrayList<>();

        Connection conn = DB.getConnection();
        try (PreparedStatement stmt = conn.prepareStatement("select Username from Courier order by Profit desc"); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(rs.getString("Username"));
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }

        return list;
    }

    @Override
    public BigDecimal getAverageCourierProfit(int numberOfDeliveries) {

        Connection conn = DB.getConnection();
        try (PreparedStatement stmt = conn.prepareStatement("select AVG(Profit) from Courier where DeliveredPackages >= ?")) {
            stmt.setInt(1, numberOfDeliveries);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getBigDecimal(1);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }

        // TODO da li vraca null?
        return null;
    }
}
