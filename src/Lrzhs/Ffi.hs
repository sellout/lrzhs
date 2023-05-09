{-# LANGUAGE ForeignFunctionInterface #-}

module Lrzhs.Ffi where

import Data.Text (Text, unpack)
import Data.Word (Word32)
import Foreign.C (CBool (..))
import Foreign.C.String (CString)
import Foreign.Ptr ()
import Lrzhs.Types (Network (..))

foreign import ccall "lrzhs_is_valid_shielded_address" rs_is_valid_sapling_address :: CString -> Word32 -> IO CBool

networkId :: Network -> Word32
networkId = \case
  Mainnet -> 1
  Testnet -> 0
