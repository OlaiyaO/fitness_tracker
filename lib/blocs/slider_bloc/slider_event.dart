 abstract class SliderEvent {}

 class LoadSliderValues extends SliderEvent {}

 class UpdateSliderValues extends SliderEvent {
   final double value1;
   final double value2;
   final double value3;

   UpdateSliderValues(this.value1, this.value2, this.value3);
 }