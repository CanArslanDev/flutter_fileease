
## Yapılacaklar
 - kullanıcı dosya transferindeyken connectiondan çıkamıyor
 - Kullanıcının telefonda ve veri tabanında depolama alanı yeri olup olmadığı kontrol edilip dosyalar öyle eklenebilecek (transfer esnasında)
 - dosya transferinden çıktıktan sonra userda ki lastConnectionsda temizleniyor mu kontrol edilecek (değişmemesi lazım)
 - qr code sayfası açıldığında yukarıdan (inappnotificationsdan) connection request snackbarı gelmeyecek
 - Connection requester 5 dakikadan sonra kabul edilemeyecek, ve kullanıcı uygulamayı kapadıysa da kabul edilemeyecek
Timestamp kullanılarak yapılacak, ve timestamp kullanıldığında connectionrequestlerde aynı kişiden fazla request geldiğinde silinme işlemini timestampe göre yaparak birden fazla aynı anda requested silinmesininde önüne geçilmiş olacak
 - çok biriktiğinde last connections request gibi verilerin aktarımı uzun sürebiliyor, eğer kullanıcı o an bağlantıda ise bağlantı hızını etkileyebilir, bunun önüne geçmek için bağlantıdayken kodu durduran bir sistem yapılabilir. 
 - constants.dart dosyası oluşturulup içine cloud storage files klasörü veya profilePhotos gibi yerler girilecek
 - uygulama min sdk 20 olacak (build.gradle),
 - info.plist [buradakiler](https://pub.dev/packages/qr_code_scanner) eklenecek
 - uygulama sadece portrait modda açılacak
 - theme modda kullanılan SchedulerBinding.instance.platformDispatcher.platformBrightness sadece uygulama açıldığında yenilendiğinden dolayı kullanıcı uygulamayı arka plana alıp telefon temasını değiştirdiğinde tema yenilenmiyor, o düzeltilecek

## connection conditionları (kalanlar opsiyonel ileride yapılabilir)
 - ~~Herhangi bir taraf bağlantıdan çıkarsa~~
 - Herhangi bir tarafın uygulaması kapanırsa (düşünülebilir)
 - ~~Herhangi bir taraf iptal ederse~~
 - Herhangi bir hata çıkarsa
 - Dosya gönderimindeyken farklı bir kullanıcıdan dosya transferi isteği gelirse ya kabul edemeyecek ya da kabul etmek istiyor musunuz diye yazı çıkacak ve evet der bise bu dosya gönderimi iptal olup ona bağlanacak
 - Dosya gönderiminde iki istek gelindiğinde biri kabul edilip dosya gönderimi başlatıldığında başka biri tarafından yine istek kabul edilirse o bağlantıya bağlanılmayacak. Bu hem gönderen hem alıcı için geçerli.
## İleriki Zaman İçin
 - user model için tomap ve formap user modele taşınacak
 - user bloc içinde ki firebase ayrı bir dosyaya taşınacak
 - user modelinde ki connectionRequest, connectedUser ve previousConnectionRequest için Model oluşturulacak ve isimleri connectionRequests ve previousConnectionRequests olarak değiştirilecek, connectionRequest model oluşturulduktan sonra userblocta ki acceptRequest ve acceptRequestQR fonksiyonunda ki map model ile değiştirilecek.
 - Update uyarı sistemi ekleyelim
 - google analytics ekleyelim
 - qrscanner sayfası için bloc oluşturulacak
 - sanırım user listenda veri gelince tüm modeli en baştan set ediyor, hangi veri değiştiyse onu set edecek şekilde değiştirilecek, sonra da id için oluşturduğumuz animatedtext stateless olarak homepagede yapılabiliyor mu diye bakılacak
 - connection request listeleri telefonda tutulacak ve cache kaydedilecek tekrar yüklenmemesi için
 - userblocta ki setUserConnectionsLists listesi içinde ki değerler sürekli emit olarak güncelleniyor, bu değerler sadece receive page de gözüktüğü için receive page açıldığında emit olarak güncellenecek şekilde değiştirilebilir, yapılabiliyorsa navigation servicede ki ckey ile yapılırsa çok daha sağlıklı olur
 - connection requestler için shimmer eklenebilir,  loading verisi geliyor modelden
 - bir kullanıcı connectiondan çıktığında diğer kullanıcı alert dialog olarak diğer kullanıcının çıktığı bilgisi verilebilir

## Yapılanlar

 - ~~userda ki latestConnectionsa veri transferindeyken veri gidip yenilenecek~~
 - ~~url download enumı değişmesi için liste eklenecek ~~
 - ~~Connection dökümanında olacaklar~~
 - ~~Döküman adı idlerin küçükten büyüğe sıralanıp arasına - işareti konulmasıyla oluşacak~~
 - ~~İçeriği~~
 - ~~Alıcı kullanıcı id (receiverID)~~
 - ~~Gönderici kullanıcı id(senderID)~~
 - ~~Dosya statüsü  (enum, fileInfo)~~
 - ~~Toplam dosya sayısı (filesCount)~~
 - ~~Toplam dosya boyutu (filesSize)~~
 - ~~Gönderim hızı (sendSpeed)~~
 - ~~Gönderilen dosyaların isimleri, dosya boyutları, hangi uzantılı oldukları, hangi dosyaların gönderildiği bilgileri (map, filesList)~~
 - ~~Bağlanırken blogda ki connectedUser güncellenecek~~
 - ~~Bağlantı bittiğinde sendListe veri eklenecek~~
 - ~~Receiver için istek kabul edildiğinde file page yönlendilirilecek~~
 - ~~FirebaseSendFileUploading düzenlenecek~~
 - ~~send file için map şeklinde kullanıcı datası alınacak~~

