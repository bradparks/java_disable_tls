import java.util.Iterator;
import java.util.Map;
import java.util.TreeMap;
import javax.net.ssl.SSLServerSocketFactory;

public class DumpCiphers
{
    public static void main(String[] args)
        throws Exception
    {
        SSLServerSocketFactory ssf = (SSLServerSocketFactory)SSLServerSocketFactory.getDefault();

        String[] defaultCiphers = ssf.getDefaultCipherSuites();
        String[] availableCiphers = ssf.getSupportedCipherSuites();

        TreeMap<String,Boolean> ciphers = new TreeMap<String,Boolean>();

        for(int i=0; i<availableCiphers.length; ++i )
            ciphers.put(availableCiphers[i], Boolean.FALSE);

        for(int i=0; i<defaultCiphers.length; ++i )
            ciphers.put(defaultCiphers[i], Boolean.TRUE);

        System.out.println("state\tcipher");
        for(Iterator i = ciphers.entrySet().iterator(); i.hasNext(); ) {
            Map.Entry cipher=(Map.Entry)i.next();

            if(Boolean.TRUE.equals(cipher.getValue()))
                System.out.print("enabled ");
            else
                System.out.print("disabled");

            System.out.print('\t');
            System.out.println(cipher.getKey());
        }
    }
}
