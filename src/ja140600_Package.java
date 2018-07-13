package student;

import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.Random;
import operations.PackageOperations;

class Coordinates {

    private Integer x;
    private Integer y;

    public Coordinates(Integer x, Integer y) {
        this.x = x;
        this.y = y;
    }

    public Integer getX() {
        return x;
    }

    public Integer getY() {
        return y;
    }
}

public class ja140600_Package implements PackageOperations {

    class MyPair<A, B> implements PackageOperations.Pair<A, B> {

        private A a;
        private B b;

        public MyPair(A a, B b) {
            this.a = a;
            this.b = b;
        }

        @Override
        public A getFirstParam() {
            return a;
        }

        @Override
        public B getSecondParam() {
            return b;
        }
    }

    private static Double calculateDistance(Coordinates a, Coordinates b) {
        return Math.sqrt(Math.pow(a.getX() - b.getX(), 2) + Math.pow(a.getY() - b.getY(), 2));
    }

    private static boolean setPackageStatus(Integer packageId, Integer status) {

        Connection conn = DB.getConnection();

        try (PreparedStatement stmt = conn.prepareStatement("update Package set Status = ? where IdPackage = ?")) {
            stmt.setInt(1, status);
            stmt.setInt(2, packageId);
            if (stmt.executeUpdate() == 1) {
                return true;
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }

        return false;
    }

    private static Coordinates getPackageFromCoordinates(int packageId) {

        Connection conn = DB.getConnection();

        Coordinates ret = null;

        String query = "select d.X, d.Y from Package p inner join District d on p.DistrictFrom = d.IdDistrict and p.IdPackage = ?";

        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, packageId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    ret = new Coordinates(rs.getInt(1), rs.getInt(2));
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }

        return ret;
    }

    private static Coordinates getPackageToCoordinates(int packageId) {

        Connection conn = DB.getConnection();

        Coordinates ret = null;

        String query = "select d.X, d.Y from Package p inner join District d on p.DistrictTo = d.IdDistrict and p.IdPackage = ?";

        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, packageId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    ret = new Coordinates(rs.getInt(1), rs.getInt(2));
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }

        return ret;
    }

    public static BigDecimal getPackagePrice(int packageId) {

        Connection conn = DB.getConnection();

        try (PreparedStatement stmt = conn.prepareStatement("select Price from Package where IdPackage = ?")) {
            stmt.setInt(1, packageId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (!rs.next() || rs.wasNull()) {
                    return null;
                }
                return rs.getBigDecimal("Price");

            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }

        return null;
    }

    @Override
    public int insertPackage(int districtFrom, int districtTo, String username, int type, BigDecimal weight) {

        Connection conn = DB.getConnection();

        try (CallableStatement cs = conn.prepareCall("{ ? =  call PR_Insert_Package(?,?,?,?,?) }")) {
            cs.registerOutParameter(1, Types.INTEGER);
            cs.setInt(2, districtFrom);
            cs.setInt(3, districtTo);
            cs.setString(4, username);
            cs.setInt(5, type);
            cs.setDouble(6, weight.doubleValue());

            cs.execute();

            return cs.getInt(1);

        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }

        return -1;

    }

    @Override
    public int insertTransportOffer(String courierUsername, int packageId, BigDecimal pricePercentage) {

        Connection conn = DB.getConnection();

        if (pricePercentage == null) {
            pricePercentage = new BigDecimal(new Random().nextDouble() * 20 - 10);
        }

        try (CallableStatement cs = conn.prepareCall("{ ? =  call PR_Insert_Offer(?,?,?) }")) {
            cs.registerOutParameter(1, Types.INTEGER);
            cs.setString(2, courierUsername);
            cs.setInt(3, packageId);
            cs.setDouble(4, pricePercentage.doubleValue());

            cs.execute();

            return cs.getInt(1);

        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }

        return -1;
    }

    @Override
    public boolean acceptAnOffer(int offerId) {

        Connection conn = DB.getConnection();

        try (PreparedStatement stmt = conn.prepareStatement("insert into AcceptedOffer(IdOffer, AcceptedTime) values (?,?)")) {
            stmt.setInt(1, offerId);
            stmt.setDate(2, (Date) new java.sql.Date(Calendar.getInstance().getTimeInMillis()));

            if (stmt.executeUpdate() != 0) {
                return true;
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }

        return false;
    }

    @Override
    public List<Integer> getAllOffers() {
        List<Integer> list = new ArrayList<>();

        Connection conn = DB.getConnection();

        try (PreparedStatement stmt = conn.prepareStatement("select IdOffer from Offer"); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(rs.getInt("IdOffer"));
            }

        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }
        return list;
    }

    @Override
    public List<Pair<Integer, BigDecimal>> getAllOffersForPackage(int packageId) {
        List<Pair<Integer, BigDecimal>> list = new ArrayList<>();

        Connection conn = DB.getConnection();

        try (PreparedStatement stmt = conn.prepareStatement("select IdOffer, Percentage from Offer where IdPackage = ?")) {
            stmt.setInt(1, packageId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(new MyPair(rs.getInt(1), rs.getBigDecimal(2)));
                }
            }

        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }
        return list;
    }

    @Override
    public boolean deletePackage(int packageId) {

        Connection conn = DB.getConnection();
        
        try (PreparedStatement stmt = conn.prepareStatement("delete from Package where IdPackage = ? and Status <= 1")) {
            stmt.setInt(1, packageId);
            if (stmt.executeUpdate() != 0) {
                return true;
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }
        return false;
    }

    @Override
    public boolean changeWeight(int packageId, BigDecimal newWeight) {

        Connection conn = DB.getConnection();

        //TODO ne sme imati ponude i mora biti status = 0 (kreiran)
        if (!getAllOffersForPackage(packageId).isEmpty()) {
            return false;
        }

        try (PreparedStatement stmt = conn.prepareStatement("update Package set Weight = ? where IdPackage = ? and Status = 0")) {
            stmt.setDouble(1, newWeight.doubleValue());
            stmt.setInt(2, packageId);
            if (stmt.executeUpdate() == 1) {
                return true;
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }

        return false;
    }

    @Override
    public boolean changeType(int packageId, int newType) {

        Connection conn = DB.getConnection();

        //TODO ne sme imati ponude i mora biti status = 0 (kreiran)
        if (!getAllOffersForPackage(packageId).isEmpty()) {
            return false;
        }

        try (PreparedStatement stmt = conn.prepareStatement("update Package set IdPackageInfo = ? where IdPackage = ? and Status = 0")) {
            stmt.setInt(1, newType);
            stmt.setInt(2, packageId);
            if (stmt.executeUpdate() == 1) {
                return true;
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }

        return false;
    }

    @Override
    public Integer getDeliveryStatus(int packageId) {

        Connection conn = DB.getConnection();

        try (PreparedStatement stmt = conn.prepareStatement("select Status from Package where IdPackage = ?")) {
            stmt.setInt(1, packageId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }

        return null;
    }

    @Override
    public BigDecimal getPriceOfDelivery(int packageId) {

        return ja140600_Package.getPackagePrice(packageId);
    }

    @Override
    public Date getAcceptanceTime(int packageId) {
        // Date - time of acceptance. If it is not yet accepted, return null.

        Connection conn = DB.getConnection();

        try (PreparedStatement stmt = conn.prepareStatement("select AcceptedTime from AcceptedOffer where idOffer = ?")) {
            stmt.setInt(1, packageId);
            ResultSet rs = stmt.executeQuery();
            if (!rs.next()) {
                return null;
            }
            return rs.getDate("AcceptedTime");
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }

        return null;

    }

    @Override
    public List<Integer> getAllPackagesWithSpecificType(int type) {

        List<Integer> list = new ArrayList<>();

        Connection conn = DB.getConnection();

        try (PreparedStatement stmt = conn.prepareStatement("select IdPackage from Package where IdPackageInfo = ?")) {
            stmt.setInt(1, type);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(rs.getInt("IdPackage"));
                }
            }

        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }
        return list;
    }

    @Override
    public List<Integer> getAllPackages() {
        List<Integer> list = new ArrayList<>();

        Connection conn = DB.getConnection();

        try (PreparedStatement stmt = conn.prepareStatement("select IdPackage from Package"); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(rs.getInt("IdPackage"));
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }
        return list;
    }

    @Override
    public List<Integer> getDrive(String courierUsername) {
        List<Integer> list = new ArrayList<>();

        Connection conn = DB.getConnection();

        String query = "select o.IdPackage, a.AcceptedTime from Courier c "
                + "inner join Offer o on c.Username = o.Username "
                + "inner join AcceptedOffer a on a.IdOffer = o.IdOffer "
                + "inner join Package p on p.IdPackage = o.IdPackage and p.Status <> 3 "
                + "order by a.AcceptedTime asc";

        try (PreparedStatement stmt = conn.prepareStatement(query); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                list.add(rs.getInt(1));
            }
        } catch (SQLException ex) {
            ex.printStackTrace(System.out);
        }

        return list;
    }

    @Override
    public int driveNextPackage(String courierUsername) {

        if (!ja140600_Courier.existsCourier(courierUsername)) {
            return -2;
        }

        List<Integer> list = getDrive(courierUsername);

        if (list.isEmpty()) { // nema sta da vozi
            if (ja140600_Courier.getCourierStatus(courierUsername) == 1) {
                ja140600_Courier.setCourierStatus(courierUsername, 0);
            }
            return -1;
        }

        // ako vrece voznju
        if (ja140600_Courier.getCourierStatus(courierUsername) == 0) {
            ja140600_Courier.setCourierStatus(courierUsername, 1);
        }

        ja140600_Package.setPackageStatus(list.get(0), 3);

        Double traveledDistance = ja140600_Package.calculateDistance(
                ja140600_Package.getPackageFromCoordinates(list.get(0)),
                ja140600_Package.getPackageToCoordinates(list.get(0))
        );

        if (list.size() > 1) {
            traveledDistance += ja140600_Package.calculateDistance(
                    ja140600_Package.getPackageToCoordinates(list.get(0)),
                    ja140600_Package.getPackageFromCoordinates(list.get(1))
            );
            ja140600_Package.setPackageStatus(list.get(1), 2);
        }

        Double packagePrice = ja140600_Package.getPackagePrice(list.get(0)).doubleValue();
        Double currentCourierProfit = ja140600_Courier.getCourierProfit(courierUsername).doubleValue();
        Double courierFuelEff = ja140600_Courier.getCourierFuelConsumption(courierUsername).doubleValue();
        Double fuelPrice = ja140600_Courier.getCourierFuelPrice(courierUsername).doubleValue();

        ja140600_Courier.setCourierProfit(courierUsername,
                new BigDecimal(
                        currentCourierProfit
                        + packagePrice
                        + traveledDistance * courierFuelEff * fuelPrice)
        );

        ja140600_Courier.setCourierDeliveredPackages(courierUsername, ja140600_Courier.getCourierDeliveredPackages(courierUsername) + 1);

        return list.get(0);
    }

}
