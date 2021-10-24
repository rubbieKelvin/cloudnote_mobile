#ifndef CXX_CORE_h
#define CXX_CORE_h
#include <iostream>
#include <string>

/*
This library is based of my original crypting library at https://pypi.org/project/pycxx/
*/

namespace cxx {
    std::string printables {"01lmnrstuvw23>?@|}~\n456ohijkxyzABCefP%&'(DEFGHpqUVWXYZ!\"#$789abcd)*+,-.gIJQRSTKLM[\\]^_`{NO/:;<=\t "};

    std::string code (std::string word, unsigned int key, bool reverse){
        // this function can encode or decode a string
        std::string result;
        std::string chars = printables;

        for (unsigned int i {0}; i<word.length(); i+=1){
            // flip
            if (reverse)
                chars = chars.substr(chars.size()-key) + chars.substr(0, chars.size()-key);
                // std::cout << chars << std::endl;
            else
                chars = chars.substr(key) + chars.substr(0, key);

            // get the index of the character in chars at i
            long unsigned int index {chars.find(word[i])};
            if (index == std::string::npos){
                result += word[i];
                continue;
            }
            // add the character at the index $index or printable to result
            result += printables[index];
        }
        return result;
    }

    std::string encode (std::string word, unsigned int key) {
        return code(word, key, false);
    }

    std::string decode (std::string word, unsigned int key) {
        return code(word, key, true);
    }
}

#endif
