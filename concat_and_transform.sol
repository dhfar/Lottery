/*функция конкатенации строк
         *Создано Вопиловым А.
         *@_a первая строка
         *@_b вторая строка
         *@return строка после сложения
         *3.11.2017
         */
        function strConcat(string _a, string _b) internal returns (string)
        {
            bytes memory _ba = bytes(_a);
            bytes memory _bb = bytes(_b);
            string memory abcde = new string(_ba.length + _bb.length);
            bytes memory babcde = bytes(abcde);
            uint k = 0;
            for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
            for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
            return string(babcde);
        }
        
        /*функция преобразования чисел в байтовую последовательность
         *Создано Вопиловым А.
         *@_a числовая строка
         *@return байтовая строка
         *3.11.2017
         */
        function uintToBytes(uint v) constant internal returns (bytes32 ret)
        {
            if (v == 0)
            {
                ret = '0';
            }
            else
            {
                while (v > 0)
                {
                    ret = bytes32(uint(ret) / (2 ** 8));
                    ret |= bytes32(((v % 10) + 48) * 2 ** (8 * 31));
                    v /= 10;
                }
            }
            return ret;
        }
        
        /*функция преобразования числа в строку
         *Создано Вопиловым А.
         *@_a числовая строка
         *@return байтовая строка
         *3.11.2017
         */
        function uint8ToString (uint8 v1) internal returns (string)
        {
            bytes32 data = uintToBytes(v1);
            bytes memory bytesString = new bytes(32);
            for (uint j=0; j<8; j++)
            {
                byte char = byte(bytes32(uint(data) * 2 ** (8 * j)));
                if (char != 0)
                {
                    bytesString[j] = char;
                }
            }
            return string(bytesString);
        }
    
    
    /*Проверка нахождения элемента в массиве
         *Создано Вопиловым А.
         *@search_number искомое число
         *@array_to_search массив, в котором ищем
         *6.11.2017
         */
        function in_array(uint8 search_number, uint8[4] array_to_search) internal returns (bool success)
        {
            for (uint i = 0; i < 4; i++)
                if(search_number == array_to_search[i])
                    return true;
            return false;
        }