package student;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import operations.DistrictOperations;

public class ja140600_District implements DistrictOperations {

    @Override
    public int insertDistrict(String name, int idCity, int X, int Y) {
        Connection conn = DB.getConnection();
        try (PreparedStatement stmt = conn.prepareStatement("insert into District(Name, X, Y, IdCity) values (?,?,?,?)",
                Statement.RETURN_GENERATED_KEYS)) {
            stmt.setString(1, name);
            stmt.setInt(2, X);
            stmt.setInt(3, Y);
            stmt.setInt(4, idCity);

            if (stmt.executeUpdate() == 0) {
                return -1;
            }

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return (int) generatedKeys.getLong(1);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }
        return -1;
    }

    @Override
    public int deleteDistricts(String... names) {

        Connection conn = DB.getConnection();

        StringBuilder builder = new StringBuilder();

        for (int i = 0; i < names.length; i++) {
            builder.append("?,");
        }

        builder.deleteCharAt(builder.length() - 1);

        try (PreparedStatement stmt = conn.prepareStatement("delete from District where Name in (" + builder.toString() + ")")) {
            for (int i = 0; i < names.length; i++) {
                stmt.setString(i + 1, names[i]);
            }
            return stmt.executeUpdate();

        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }

        return 0;
    }

    @Override
    public boolean deleteDistrict(int idDistrict) {

        Connection conn = DB.getConnection();

        try (PreparedStatement stmt = conn.prepareStatement("delete from District where IdDistrict = ?")) {
            stmt.setInt(1, idDistrict);

            if (stmt.executeUpdate() == 1) {
                return true;
            }

        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }
        return false;
    }

    @Override
    public int deleteAllDistrictsFromCity(String nameOfTheCity) {
        int idCity = -1;

        Connection conn = DB.getConnection();

        try (PreparedStatement stmt = conn.prepareStatement("select IdCity from City where Name = ?")) {
            stmt.setString(1, nameOfTheCity);
            try (ResultSet rs = stmt.executeQuery()) {
                if (!rs.next()) {
                    return 0;
                }
                idCity = rs.getInt("IdCity");
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }

        try (PreparedStatement stmt = conn.prepareStatement("delete from District where IdCity = ?")) {
            stmt.setInt(1, idCity);
            return stmt.executeUpdate();
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }

        return 0;
    }

    @Override
    public List<Integer> getAllDistrictsFromCity(int idCity) {
        List<Integer> list = new ArrayList<>();

        Connection conn = DB.getConnection();

        try (PreparedStatement stmt = conn.prepareStatement("select IdCity from City where IdCity = ?")) {
            stmt.setInt(1, idCity);
            try (ResultSet rs = stmt.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
            return null;
        }

        try (PreparedStatement stmt = conn.prepareStatement("select IdDistrict from District where IdCity = ?");) {
            stmt.setInt(1, idCity);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(rs.getInt("IdDistrict"));
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }

        return list;
    }

    @Override
    public List<Integer> getAllDistricts() {
        List<Integer> list = new ArrayList<>();

        Connection conn = DB.getConnection();
        try (PreparedStatement stmt = conn.prepareStatement("select IdDistrict from District"); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(rs.getInt("IdDistrict"));
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }

        return list;
    }

}
