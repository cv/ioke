package org.ioke

import scala.collection.mutable

class iokeState {
  override def toString() = "iokeState"
  def debugString() = "#<iokeState>"

  val symbols = mutable.Map[String, iokeObject]()
  var objectProto : iokeObject = iokeObject.prototype(this)
  var symbolProto : iokeObject = SymbolData.prototype(this)
  var arrayProto : iokeObject = ArrayData.prototype(this)
  var messageProto : iokeObject = MessageData.prototype(this)

  var activateSymbol : iokeObject = sym("activate")
  var forwardSymbol : iokeObject = sym("forward")
  var selfSymbol : iokeObject = sym("self")

  var setSlotSymbol : iokeObject = sym("set-slot")
  var internalSetSlotSymbol : iokeObject = sym("internal:set-slot")

  var callSymbol : iokeObject = sym("call")
  var typeSymbol : iokeObject = sym("type")

  var semicolon : iokeObject = sym(";")
  
  var stringProto = objectProto.CLONE
  stringProto.meta.name = "String"
  stringProto.setSlotTo(sym("type"), sym("String"))

  // var bufferProto = BufferData.prototype(this)
  
  symbolProto.setPrototypeTo(stringProto)

  arrayProto.setPrototypeTo(objectProto)

  var protos = objectProto.CLONE
  var core = objectProto.CLONE
  var topLevel = objectProto.CLONE

  topLevel.setSlotTo(sym("TopLevel"), topLevel)
  topLevel.setSlotTo(sym("Protos"), protos)
  protos.setSlotTo(sym("Core"), core)

  objectProto.setPrototypeTo(topLevel)
  topLevel.setPrototypeTo(protos)
  protos.setPrototypeTo(core)

  core.setSlotTo(sym("Object"), objectProto)
  core.setSlotTo(sym("Array"), arrayProto)
  core.setSlotTo(sym("Symbol"), symbolProto)
  core.setSlotTo(sym("Message"), messageProto)

//  var localsProto : iokeObject = objectProto.CLONE

  var iokeNil : iokeObject = objectProto.CLONE
  core.setSlotTo(sym("nil"), iokeNil)

  var iokeTrue : iokeObject = objectProto.CLONE
  core.setSlotTo(sym("true"), iokeTrue)
  iokeTrue.setSlotTo(sym("type"), sym("true"))

  var iokeFalse : iokeObject = objectProto.CLONE 
  core.setSlotTo(sym("false"), iokeFalse)
  iokeFalse.setSlotTo(sym("false"), sym("false"))

  def sym(value: String) : iokeObject = {
    if(symbols.contains(value)) {
      symbols(value)
    } else {
      val symbol = SymbolData.newSymbolWithString(this, value)
      addSymbol(value, symbol)
      symbol
    }
  } 

  def addSymbol(value : String, symbol : iokeObject) = {
    symbols += Pair(value, symbol)
    symbol.isSymbol = true
  }
  
  //Equivalent of IoMessage_newWithName_
  def msg(value: String) : iokeObject = null  
  def msg(value: MessageData) : iokeObject = {
    val o = messageProto.CLONE
    o.data = value
    o
  }
}
