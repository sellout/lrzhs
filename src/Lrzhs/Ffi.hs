{-# LANGUAGE ForeignFunctionInterface #-}
{-# LANGUAGE ForeignFunctionInterface #-}
module Lrzhs.Ffi
where

import Foreign.C (CBool(..))
import Foreign.C.String (CString, withCString)
import Foreign.Ptr ()
import Data.Text (Text, unpack)
import Data.Word (Word32)
import Lrzhs.Types (Network(..))

foreign import ccall "lrzhs_is_valid_shielded_address" rs_is_valid_sapling_address :: CString -> Word32 -> IO CBool

networkId :: Network -> Word32
networkId = \case
  Mainnet -> 1
  Testnet -> 0

isValidSaplingAddress :: Text -> Network -> IO Bool
isValidSaplingAddress t n = fmap (\(CBool b) -> b /= 0) $ withCString (unpack t) (\cs -> rs_is_valid_sapling_address cs (networkId n))

