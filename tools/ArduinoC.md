# Arduino C语法

[**详细可以参考已有文件**](../resources/arduino语言说明.pdf)

## 数据类型

boolean 布尔
char 字符类型
byte 字节类型
int 整数类型
unsigned int 无符号整型
long 长整型
unsigned long 无符号长整型
float 实数类型
double
string
array
void

## 常量

HIGH / LOW 表示数字IO的电平
INPUT / OUTPUT 表示数字IO口的方向，INPUT表示输入，OUTPUT表示输出
true/ false 表示真假

## 结构

void setup() 初始化发量，管脚模式，调用库函数
void loop() 连续执行函数内的语句

## 功能

**数字IO**
- pinMode(pin, mode) 输入输出IO口模式定义函数，pin表示为0~13，mode表示INPUT或者OUTPUT
- digitalWrite(pin, value) 数字IO口输出电平定义函数，pin表示0~13，value表示为HIGH或者LOW
- int digitalRead(pin) shuziio口读取输入电平函数，pin表示0~13返回值表示高电平或者低电平HIGH or LOW

**模拟IO**
- int analogRead(pin)\_ 模拟io口读函数，pin表示0~5(根据硬件的接口来定)
- analogWrite(pin, value)\_PWM 数字io口PWM输出函数，arduino数字io口标注了PWM的IO口可使用该函数，pin表示3，5，6，9，10，11，value表示0~255

**时间函数**
- delay(ms) 延时函数，单位ms
- delayMicroseconds(us) 延时函数，单位us

**数学函数**
- min(x, y) 求最小值
- max(x, y) 求最大值
- abs(x) 计算绝对值
- constrain(x, a, b) 约束函数，下限a， 上限b， x必须在ab之间才能返回
- map(value, fromLow, fromHigh, toLow, toHigh) 约束函数，value必须在范围值之间
- pow(base, exponent) 开方函数，base的exponent次方
- sq(x) 平方
- sqrt(x) 开平方
















