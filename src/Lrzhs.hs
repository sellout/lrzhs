module Lrzhs (isValidSaplingAddress) where

import Data.Text (Text, unpack)
import Foreign.C (CBool (..))
import Foreign.C.String (withCString)
import Lrzhs.Ffi (networkId, rs_is_valid_sapling_address)
import Lrzhs.Types (Network)

isValidSaplingAddress :: Text -> Network -> IO Bool
isValidSaplingAddress t n = fmap (\(CBool b) -> b /= 0) $ withCString (unpack t) (\cs -> rs_is_valid_sapling_address cs (networkId n))
