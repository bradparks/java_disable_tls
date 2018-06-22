// Code originally from http://www.devdaily.com/blog/post/java/simple-https-example

import java.net.URL;
import java.io.*;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.SSLSession;

public class TestOutboundConnection
{
  public static void main(String[] args) throws Exception
  {
    HttpsURLConnection.setDefaultHostnameVerifier(
        new HostnameVerifier() {
          public boolean verify(String hostname, SSLSession sess)
          {
            System.out.println("hostname = "+hostname);
            System.out.println("sess.getPeerHost()= "+sess.getPeerHost());
            return true;
          }
        }
      );

    test(args[0]);
  }

  private static void test(String httpsURL) throws Exception
  {
    URL myurl = new URL(httpsURL);
    HttpsURLConnection con = (HttpsURLConnection)myurl.openConnection();
    InputStream ins = con.getInputStream();
    InputStreamReader isr = new InputStreamReader(ins);
    BufferedReader in = new BufferedReader(isr);

    String inputLine;

    while ((inputLine = in.readLine()) != null)
    {
      //System.out.println(inputLine);
    }

    in.close();
    con.disconnect();
  }
}
