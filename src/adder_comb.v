
//! Простой комбинационный параметризируемый беззнаковый сумматор.
//! Разрядность результата суммирования на один бит больше разрядности слагаемых.

//! { signal: [
//!  { name: "data1_i", wave: "====", data: ["4", "9",  "13", "5"] },
//!  { name: "data2_i", wave: "====", data: ["1", "3",  "13", "2"] },
//!  { name: "data_o",  wave: "====", data: ["5", "12", "26", "7"] }
//! ],
//!  head:{
//!     text:'Временные диаграммы работы'
//!  },
//!  config: {
//!    hscale: 3
//!  }
//!}

module adder_comb #(
    parameter integer WIDTH = 4     //! разрядность слагаемых
) (
    input  [WIDTH-1:0] data1_i,     //! первое слагаемое
    input  [WIDTH-1:0] data2_i,     //! второе слагаемое
    output [  WIDTH:0] data_o       //! результат сложения
);

  //! непрерывное присваивание, реализующее суммирование
  assign data_o = data1_i + data2_i;

endmodule