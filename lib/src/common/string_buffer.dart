// extension on RuneIterator {
//   int nextCodePoint() {
//     var value = -1;
//     if (moveNext()) {
//       value = current;
//       movePrevious();
//     }
//     return value;
//   }
// }

// extension ShittyStringBufferExtensions on StringBuffer {
//   prepare(RuneIterator src, int options) {
//     //       StringBuffer mapOut = map(src,options);
//     //       StringBuffer normOut = mapOut;// initialize
//   }
//   // public StringBuffer prepare(UCharacterIterator src, int options)
//   //                       throws ParseException{

//   //       // map

//   //       if(doNFKC){
//   //           // normalize
//   //           normOut = normalize(mapOut);
//   //       }

//   //       int ch;
//   //       char result;
//   //       UCharacterIterator iter = UCharacterIterator.getInstance(normOut);
//   //       Values val = new Values();
//   //       int direction=UCharacterDirection.CHAR_DIRECTION_COUNT,
//   //           firstCharDir=UCharacterDirection.CHAR_DIRECTION_COUNT;
//   //       int rtlPos=-1, ltrPos=-1;
//   //       boolean rightToLeft=false, leftToRight=false;

//   //       while((ch=iter.nextCodePoint())!= UCharacterIterator.DONE){
//   //           result = getCodePointValue(ch);
//   //           getValues(result,val);

//   //           if(val.type == PROHIBITED ){
//   //               throw new ParseException("A prohibited code point was found in the input" +
//   //                                        iter.getText(), val.value);
//   //           }

//   //           direction = UCharacter.getDirection(ch);
//   //           if(firstCharDir == UCharacterDirection.CHAR_DIRECTION_COUNT){
//   //               firstCharDir = direction;
//   //           }
//   //           if(direction == UCharacterDirection.LEFT_TO_RIGHT){
//   //               leftToRight = true;
//   //               ltrPos = iter.getIndex()-1;
//   //           }
//   //           if(direction == UCharacterDirection.RIGHT_TO_LEFT || direction == UCharacterDirection.RIGHT_TO_LEFT_ARABIC){
//   //               rightToLeft = true;
//   //               rtlPos = iter.getIndex()-1;
//   //           }
//   //       }
//   //       if(checkBiDi == true){
//   //           // satisfy 2
//   //           if( leftToRight == true && rightToLeft == true){
//   //               throw new ParseException("The input does not conform to the rules for BiDi code points." +
//   //                                        iter.getText(),
//   //                                        (rtlPos>ltrPos) ? rtlPos : ltrPos);
//   //            }

//   //           //satisfy 3
//   //           if( rightToLeft == true &&
//   //               !((firstCharDir == UCharacterDirection.RIGHT_TO_LEFT || firstCharDir == UCharacterDirection.RIGHT_TO_LEFT_ARABIC) &&
//   //               (direction == UCharacterDirection.RIGHT_TO_LEFT || direction == UCharacterDirection.RIGHT_TO_LEFT_ARABIC))
//   //             ){
//   //               throw new ParseException("The input does not conform to the rules for BiDi code points." +
//   //                                        iter.getText(),
//   //                                        (rtlPos>ltrPos) ? rtlPos : ltrPos);
//   //           }
//   //       }
//   //       return normOut;

//   //     }

//   static const ALLOW_UNASSIGNED = 0x0001;
//   map(RuneIterator iter, int options) {
//     final values = [];

//     int result = 0;
//     int ch = -1;
//     StringBuffer dest = StringBuffer();
//     bool allowUnassigned = ((options & ALLOW_UNASSIGNED) > 0);
//     //chnage this
//     while ((ch = iter.nextCodePoint()) != -1) {
//       result = ;
//     }
//   }


//   static const DONE = -1;

// //         while((ch=iter.nextCodePoint())!= UCharacterIterator.DONE){

// //             result = getCodePointValue(ch);
// //             getValues(result,val);

// //             // check if the source codepoint is unassigned
// //             if(val.type == UNASSIGNED && allowUnassigned == false){
// //                  throw new ParseException("An unassigned code point was found in the input " +
// //                                           iter.getText(), iter.getIndex());
// //             }else if((val.type == MAP)){
// //                 int index, length;

// //                 if(val.isIndex){
// //                     index = val.value;
// //                     if(index >= indexes[ONE_UCHAR_MAPPING_INDEX_START] &&
// //                              index < indexes[TWO_UCHARS_MAPPING_INDEX_START]){
// //                         length = 1;
// //                     }else if(index >= indexes[TWO_UCHARS_MAPPING_INDEX_START] &&
// //                              index < indexes[THREE_UCHARS_MAPPING_INDEX_START]){
// //                         length = 2;
// //                     }else if(index >= indexes[THREE_UCHARS_MAPPING_INDEX_START] &&
// //                              index < indexes[FOUR_UCHARS_MAPPING_INDEX_START]){
// //                         length = 3;
// //                     }else{
// //                         length = mappingData[index++];
// //                     }
// //                     /* copy mapping to destination */
// //                     dest.append(mappingData,index,length);
// //                     continue;

// //                 }else{
// //                     ch -= val.value;
// //                 }
// //             }else if(val.type == DELETE){
// //                 // just consume the codepoint and continue
// //                 continue;
// //             }
// //             //copy the source into destination
// //             UTF16.append(dest,ch);
// //         }

// //         return dest;
// //     }
// }
