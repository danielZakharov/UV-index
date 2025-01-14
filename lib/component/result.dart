// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:uvindex/custom/theme.dart' as AppTheme;
import 'package:uvindex/localization/app_localizations.dart';
import 'package:uvindex/model/weatherbit_data.dart';
import 'package:uvindex/screen/home_page.dart';

class Result extends StatelessWidget {
//  final OpenUVResponse data;
  final WeatherbitResponse data;
  final int selectedSkin;
  static const List<String> weekdays = [
    "",
    "monday",
    "tuesday",
    "wednesday",
    "thursday",
    "friday",
    "saturday",
    "sunday"
  ];

  static const List<String> months = [
    "",
    "jan",
    "feb",
    "mar",
    "apr",
    "may",
    "jun",
    "jul",
    "aug",
    "sep",
    "oct",
    "nov",
    "dec"
  ];

  Result(this.data, this.selectedSkin);

  @override
  Widget build(BuildContext context) {
    AppTheme.Theme theme = AppTheme.Theme(data.uv, context);

    String _formatNumber(int number) {
      String ret = '0' + number.toString();
      return ret.substring(ret.length - 2, ret.length);
    }

    String _formatDesc() {
      String desc = data.description;
      if (data.description == "Clear sky") desc = "Чистое небо";
      if (data.description == "Thunderstorm with light rain")
        desc = "Гроза с небольшим дождем";
      if (data.description == "Thunderstorm with rain") desc = "Гроза с дождем";
      if (data.description == "Thunderstorm with heavy rain")
        desc = "Гроза с сильным дождем";
      if (data.description == "Thunderstorm with light drizzle")
        desc = "Гроза с мелким дождем";
      if (data.description == "Thunderstorm with drizzle")
        desc = "Гроза с моросью";
      if (data.description == "Thunderstorm with heavy drizzle")
        desc = "Гроза с сильным моросящим дождем";
      if (data.description == "Thunderstorm with Hail") desc = "Гроза с градом";
      if (data.description == "Light Drizzle") desc = "Мелкий дождь";
      if (data.description == "Drizzle") desc = "Морось";
      if (data.description == "Heavy Drizzle") desc = "Сильная изморось";
      if (data.description == "Light Rain") desc = "Легкий дождь";
      if (data.description == "Moderate Rain") desc = "Умеренный дождь";
      if (data.description == "Heavy Rain") desc = "Ливень";
      if (data.description == "Freezing rain") desc = "Холодный дождь";
      if (data.description == "Light shower rain")
        desc = "Слабый ливневый дождь";
      if (data.description == "Shower rain") desc = "Ливень";
      if (data.description == "Heavy shower rain")
        desc = "Сильный ливневый дождь";
      if (data.description == "Light snow") desc = "Слабый снег";
      if (data.description == "Snow") desc = "Снег";
      if (data.description == "Heavy Snow") desc = "Сильный снег";
      if (data.description == "Mix snow/rain") desc = "Дождь со снегом";
      if (data.description == "Sleet") desc = "Мокрый снег";
      if (data.description == "Heavy sleet") desc = "Сильный мокрый снег";
      if (data.description == "Snow shower") desc = "Снегопад";
      if (data.description == "Heavy snow shower") desc = "Сильный снегопад";
      if (data.description == "Flurries") desc = "Ветренно";
      if (data.description == "Mist") desc = "Туман";
      if (data.description == "Smoke") desc = "Легкий туман";
      if (data.description == "Haze") desc = "Мгла";
      if (data.description == "Sand/dust") desc = "Песок/пыль";
      if (data.description == "Fog") desc = "Туман";
      if (data.description == "Freezing Fog") desc = "Холодный туман";
      if (data.description == "Few clouds") desc = "Небольшая облачность";
      if (data.description == "Scattered clouds")
        desc = "Рассеянная облачность";
      if (data.description == "Broken clouds") desc = "Разорванная облачность";
      if (data.description == "Overcast clouds") desc = "Пасмурно";
      if (data.description == "Unknown Precipitation")
        desc = "Неизвестные осадки";
      return desc;
    }

    String _time_calculation(int selectedS, double uv) {
      double du = 0;
      double md;
      double hours = 0;
      double minutes = 0;
      String res;
      if (selectedS == 1)
        du = 0.8;
      else if (selectedS == 2)
        du = 1;
      else if (selectedS == 3)
        du = 1.4;
      else if (selectedS == 4)
        du = 1.8;
      else if (selectedS == 5)
        du = 2.2;
      else if (selectedS == 6) {
        du = 2.6;
      }
      md = uv * 0.43;
      hours = du / md;
      if (hours < 1) {
        minutes = 60 * hours;
        hours = 0;
      } else if (hours >= 1) {
        minutes = (60 * (hours - hours.truncate()));
      }
      res = "${hours.truncate()} ч. ${minutes.truncate()} мин.";
      return res;
    }

    String _formatDate() {
      DateTime date = data.observeTime;
      String weekday =
          AppLocalizations.of(context).translate(weekdays[date.weekday]);
      String month = AppLocalizations.of(context).translate(months[date.month]);
      return '$weekday, ${_formatNumber(date.day)} $month ${date.year} @ ${_formatNumber(date.hour)}:${_formatNumber(date.minute)}';
    }

    return Scaffold(
      //backgroundColor: theme.secondary,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text('УФ Индекс', style: TextStyle(color: Colors.white)),
        ),
        // backgroundColor: theme.primary,
        backgroundColor: Colors.orange,
      ),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
        child: Column(
          children: <Widget>[
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                data.cityName,
                textAlign: TextAlign.center,
                style: TextStyle(color: theme.text),
              ),
            ),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                '${_formatDate()}',
                textAlign: TextAlign.center,
                style: TextStyle(color: theme.text),
              ),
            ),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: RichText(
                text: TextSpan(children: [
                  WidgetSpan(
                      child: ImageIcon(
                    AssetImage('icons/${data.icon}.png'),
                    color: theme.text,
                  )),
                  TextSpan(
                    text:
                        _formatDesc(), //AppLocalizations.of(context).translate(data.description),
                    style: TextStyle(color: theme.text),
                  ),
                ]),
              ),
            ),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: RichText(
                text: TextSpan(children: [
                  WidgetSpan(
                      child: ImageIcon(
                    AssetImage('icons/temp.png'),
                    color: theme.text,
                  )),
                  TextSpan(
                    text:
                        '${data.temp}', //AppLocalizations.of(context).translate(data.description),
                    style: TextStyle(color: theme.text),
                  ),
                ]),
              ),
            ),
            Text(""),
            Container(
              width: 200.0,
              height: 200.0,
              decoration:
                  BoxDecoration(color: theme.primary, shape: BoxShape.circle),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  '${(data.uv).toStringAsFixed(2)}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 60.0),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    theme.riskLevel,
                    style: TextStyle(color: theme.text, fontSize: 40.0),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.orange,
                          width: 5,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    //color: Colors.orange,
                    height: 115,
                    width: 400,
                    child: Column(
                      children: [
                        Text(
                          'Ваше максимальное время воздействия до солнечного ожога составляет:',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: theme.text, fontSize: 20.0),
                        ),
                        Text(
                          "${_time_calculation(selectedSkin, data.uv).toString()}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: theme.text,
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${theme.description}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: theme.text, fontSize: 14.0),
                  ),
                ],
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SkinScreen(data, selectedSkin)));
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                  shadowColor: Colors.black,
                ),
                child: Text('Тип кожи')),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Advices()));
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                  shadowColor: Colors.black,
                ),
                child: Text('Рекомендации')),
          ],
        ),
      ),
    );
  }
}

class Advices extends StatefulWidget {
  @override
  State<Advices> createState() => _Advices();
}

class _Advices extends State<Advices> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Рекомендации"),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 10),
        color: Colors.white10,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ListView(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              padding: const EdgeInsets.all(0),
              children: [
                FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdvicePage(
                                "Уход за кожей до пляжа",
                                "\n1.Провести пилинг тела \n\n     Вы освободите кожу от ороговевших клеток, в результате она станет ровной и гладкой. Отшелушивание можно провести в домашних условиях, для этого понадобится скраб и/или мочалка из люфы.\n     Какой бы ни был состав у скраба, пользоваться им каждый день не стоит. Норма для сухой кожи — раз в неделю, для жирной и комбинированной — дважды в неделю.\n\n2.Усилить увлажнение\n\n     Для эффективного увлажнения важно, чтобы в состав косметического средства входили влагоудерживающие компоненты (глицерин, гиалуроновая кислота), а также компоненты, восстанавливающие защитный барьер кожи и препятствующие тем самым излишнему испарению воды.")));
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Уход за кожей до пляжа",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                Divider(),
                FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdvicePage(
                                "Уход за кожей на пляже",
                                "\n     Чтобы процесс проходил максимально безопасно, не забудьте положить в пляжную сумку солнцезащитный крем. Обновляйте защиту каждые два часа и после каждого купания, особенно если вытирались полотенцем. \n     При выборе средства, а точнее, степени защиты, помните: первые несколько дней вам понадобится высокий фактор SPF 50+, а как только кожа покроется легким загаром, можно использовать крем с SPF 20 или 30.")));
                  },
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Уход за кожей на пляже",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      )),
                ),
                Divider(),
                FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdvicePage(
                                "Уход за кожей после пляжа",
                                "\n     Сначала примите душ. Есть мнение, что если каждый раз после моря очищать кожу от соли, песка и солнцезащитных средств мягкой мочалкой, то каждый последующий слой загара будет ложиться ровнее и дольше сохраняться. При этом не стоит забывать о дополнительном увлажнении кожи.\n     На отдыхе обязательно пользуйтесь кремом после загара. Обычно в состав таких средств входят мощные влагоудерживающие и смягчающие активные вещества.")));
                  },
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Уход за кожей после пляжа",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      )),
                ),
                Divider(),
                FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdvicePage(
                                "Как правильно загорать в разное время года",
                                "\nЗимой и весной\n \n    При каждой возможности хочется подставить солнечным лучам лицо и руки. Солнце весной — ласковое, но не стоит забывать, что его повреждающее действие никто не отменял.\n\nВ начале лета\n\n     Можно приучать кожу к ультрафиолету и постепенно увеличивать продолжительность солнечных ванн, учитывая индивидуальную фоточувствительность и не доводя даже до минимального покраснения, которое:\n     •	приводит к повреждению иммунных клеток кожи;\n     •	влечет за собой снижение количества гиалуроновой кислоты на 20%;\n     •	способствует выработке ферментов, повреждающих собственный коллаген.\n     Самой комфортной считается температура 22–25 градусов. В часы, когда тень длиннее роста человека, вы получаете самый красивый загар.\n\nВ середине лета\n\n     Не стоит загорать уже после 10 утра. Следует учитывать, что у моря или на берегу реки солнце воздействуют агрессивнее, поскольку к прямым лучам добавляются отраженные от воды.\n\nВ конце лета\n\n     Световой день становится короче, снова можно чуть дольше оставаться на солнце, так как интенсивность UVВ-лучей снижается, а вместе с ней и вероятность солнечного ожога. Однако воздействие лучей типа А, вызывающих преждевременное старение кожи, остается неизменным независимо от времени года. Без должной защиты коже грозят:\n     •	гиперпигментация;\n     •	морщины;\n     •	грубая текстура и неровный рельеф.")));
                  },
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Как правильно загорать в разное время года",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      )),
                ),
                Divider(),
                FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdvicePage(
                                "Кому нельзя загорать на солнце",
                                "\n     Прежде всего, людям с аллергическими реакциями на солнце. Или, говоря научным языком, тем, кто страдает от полиморфного солнечного дерматита и солнечной крапивницы. Под воздействием ультрафиолета у таких людей появляются зудящие высыпания.\n     Лекарственные препараты с фотосенсибилизирующим эффектом делают кожу более уязвимой для вредного УФ-воздействию. Спектр таких препаратов достаточно широк: от отвара зверобоя до некоторых контрацептивов и антибиотиков. Если принимаете таблетки, перед отпуском проконсультируйтесь с врачом.\n     Список тех, кому не стоит загорать, можно дополнить. В него входят:\n     •	беременные;\n     •	младенцы до 3-х месяцев, а в идеале — дети до 3-х лет;\n     •	люди с онкологическими заболеваниями;\n     •	люди с множеством мелких и крупных родинок на теле.\n")));
                  },
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Кому нельзя загорать на солнце",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      )),
                ),
              ],
            ),
            Divider(),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.orange,
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                          shadowColor: Colors.black,
                        ),
                        child: Text('Назад'))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdvicePage extends StatefulWidget {
  final String adviceTitle;
  final String adviceText;

  AdvicePage(this.adviceTitle, this.adviceText);
  @override
  State<AdvicePage> createState() =>
      _AdvicePage(this.adviceTitle, this.adviceText);
}

class _AdvicePage extends State<AdvicePage> {
  final String adviceTitle;
  final String adviceText;

  _AdvicePage(this.adviceTitle, this.adviceText);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(adviceTitle),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 15),
        color: Colors.white10,
        child: Expanded(
          flex: 1,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    adviceTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    adviceText,
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}

/*Уход за кожей до пляжа
1.Провести пилинг тела
Вы освободите кожу от ороговевших клеток, в результате она станет ровной и гладкой. Отшелушивание можно провести в домашних условиях, для этого понадобится скраб и/или мочалка из люфы.
!!!!!!Какой бы ни был состав у скраба, пользоваться им каждый день не стоит. Норма для сухой кожи — раз в неделю, для жирной и комбинированной — дважды в неделю.
2.Усилить увлажнение
Для эффективного увлажнения важно, чтобы в состав косметического средства входили влагоудерживающие компоненты (глицерин, гиалуроновая кислота), а также компоненты, восстанавливающие защитный барьер кожи и препятствующие тем самым излишнему испарению воды.
 */
