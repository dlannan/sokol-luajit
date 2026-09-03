





























































































































































































































































































































































































































































































































































































































































































































































































































































































































































































    





















































































#pragma warning(disable: 4717)




























#pragma once









#pragma once




























    







    
    


        


            
        
    
















#pragma once





















































































































































































































































































































































































































































































































































































































































































































#pragma region Input Buffer SAL 1 compatibility macros



























































































































































































































































































































































































































































































































































































































































































































































































#pragma endregion Input Buffer SAL 1 compatibility macros


































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    
    
    
    

    
    

























































































































































































































































    
    














































































































#pragma once




































































































































































































































































































































































































#pragma once



#pragma pack(push, 8)



    


        
    





    


        
    




    





    


#pragma warning(push)
#pragma warning(disable:   4514 4820 )










    
    


        typedef unsigned int uintptr_t;
    



    
    


        typedef char* va_list;
    





    











    
    














    

    
    
    



























































































    



#pragma warning(pop) 
#pragma pack(pop)


#pragma warning(push)
#pragma warning(disable:   4514 4820 )


























    


    









    


        
    

















    




        
    



    


        
    







    
    





    












    





    



    



      
    











    typedef unsigned int     size_t;
    typedef int              ptrdiff_t;
    typedef int              intptr_t;









    typedef _Bool __vcrt_bool;




    



    



    




    
    typedef unsigned short wchar_t;



    


        
    





    















    













    



    


        
    



    


        
    



    


        
    














    
        
    









    










    


        
    








    










    


        




    







    
        
    






    void __cdecl __security_init_cookie(void);

    
        void __fastcall __security_check_cookie(  uintptr_t _StackCookie);
        __declspec(noreturn) void __cdecl __report_gsfailure(void);
    








extern uintptr_t __security_cookie;


    
    
    




#pragma warning(pop) 










    

















        
    



    



    
        
    




















    


        
    




    















    



    











        
    



    


        
    


#pragma warning(push)
#pragma warning(disable: 4324  4514 4574 4710 4793 4820 4995 4996 28719 28726 28727 )










    




        
    





    



    




        
    





    



    









    






    





    










    














    


        
    





    





    





    



    


        
    





























    typedef _Bool __crt_bool;















    
        


            
        
    




















    


        
    







    



 






  


   
  
 



 


   
 

















 void __cdecl _invalid_parameter_noinfo(void);
 __declspec(noreturn) void __cdecl _invalid_parameter_noinfo_noreturn(void);

__declspec(noreturn)
 void __cdecl _invoke_watson(
      wchar_t const* _Expression,
      wchar_t const* _FunctionName,
      wchar_t const* _FileName,
            unsigned int _LineNo,
            uintptr_t _Reserved);


    



        
        
        
        
        
        
        
        
        
        
        
        

    













    









    


        


    










    






        
    



    


        
    








































    







    





    


        


            
        
    













    


        



    



    
        
    





    
        
        
        
    





    
        
              
        


    





    
        
    





    
        
    







    









typedef int                           errno_t;
typedef unsigned short                wint_t;
typedef unsigned short                wctype_t;
typedef long                          __time32_t;
typedef __int64                       __time64_t;

typedef struct __crt_locale_data_public
{
      unsigned short const* _locale_pctype;
      int _locale_mb_cur_max;
               unsigned int _locale_lc_codepage;
} __crt_locale_data_public;

typedef struct __crt_locale_pointers
{
    struct __crt_locale_data*    locinfo;
    struct __crt_multibyte_data* mbcinfo;
} __crt_locale_pointers;

typedef __crt_locale_pointers* _locale_t;

typedef struct _Mbstatet
{ 
    unsigned long _Wchar;
    unsigned short _Byte, _State;
} _Mbstatet;

typedef _Mbstatet mbstate_t;










    


        typedef __time64_t time_t;
    




    



    typedef size_t rsize_t;











    

















































































































































        
        
        
        
        
        
        
        
        
        
        
        

    













































































    















































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































        
        
        
        

        

            


            


            


            


            


            


            


            


            



            



            


            


            


            


            


            


            


            


            


            


            



            



            



            


            



            




            

            




            

            




            

            




            

            




            

            




            

            




            

            




            

        












































    





#pragma warning(pop) 


#pragma warning(push)
#pragma warning(disable: 4324  4514 4574 4710 4793 4820 4995 4996 28719 28726 28727 )

















     void __cdecl _wassert(
          wchar_t const* _Message,
          wchar_t const* _File,
            unsigned       _Line
        );

    










#pragma warning(pop) 









#pragma once




#pragma warning(push)
#pragma warning(disable:   4514 4820 )














#pragma warning(pop) 









#pragma once















#pragma once










#pragma once










#pragma once





#pragma warning(push)
#pragma warning(disable: 4324  4514 4574 4710 4793 4820 4995 4996 28719 28726 28727 )







     int* __cdecl _errno(void);
    

     errno_t __cdecl _set_errno(  int _Value);
     errno_t __cdecl _get_errno(  int* _Value);

     unsigned long* __cdecl __doserrno(void);
    

     errno_t __cdecl _set_doserrno(  unsigned long _Value);
     errno_t __cdecl _get_doserrno(  unsigned long * _Value);











































    
    
    
    
    







    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    






#pragma warning(pop) 










#pragma once



#pragma warning(push)
#pragma warning(disable:   4514 4820 )







  
 void * __cdecl memchr(
      void const* _Buf,
                                 int         _Val,
                                 size_t      _MaxCount
    );

  
int __cdecl memcmp(
      void const* _Buf1,
      void const* _Buf2,
                         size_t      _Size
    );


 

void* __cdecl memcpy(
      void* _Dst,
            void const* _Src,
                               size_t      _Size
    );


 void* __cdecl memmove(
      void*       _Dst,
            void const* _Src,
                                   size_t      _Size
    );

 

void* __cdecl memset(
      void*  _Dst,
                               int    _Val,
                               size_t _Size
    );

  
 char * __cdecl strchr(
      char const* _Str,
        int         _Val
    );

  
 char * __cdecl strrchr(
      char const* _Str,
        int         _Ch
    );

    
 char * __cdecl strstr(
      char const* _Str,
      char const* _SubStr
    );

  

 wchar_t * __cdecl wcschr(
      wchar_t const* _Str,
        wchar_t        _Ch
    );

  
 wchar_t * __cdecl wcsrchr(
      wchar_t const* _Str,
        wchar_t        _Ch
    );

    

 wchar_t * __cdecl wcsstr(
      wchar_t const* _Str,
      wchar_t const* _SubStr
    );







#pragma warning(pop) 


#pragma warning(push)
#pragma warning(disable: 4324  4514 4574 4710 4793 4820 4995 4996 28719 28726 28727 )





    















     
    
    static __inline errno_t __cdecl memcpy_s(
          void*       const _Destination,
                                                              rsize_t     const _DestinationSize,
                                 void const* const _Source,
                                                              rsize_t     const _SourceSize
        )
    {
        if (_SourceSize == 0)
        {
            return 0;
        }

        { int _Expr_val=!!(_Destination != ((void *)0)); if (!(_Expr_val)) { (*_errno()) = 22; _invalid_parameter_noinfo(); return 22; } };
        if (_Source == ((void *)0) || _DestinationSize < _SourceSize)
        {
            memset(_Destination, 0, _DestinationSize);

            { int _Expr_val=!!(_Source != ((void *)0)); if (!(_Expr_val)) { (*_errno()) = 22; _invalid_parameter_noinfo(); return 22; } };
            { int _Expr_val=!!(_DestinationSize >= _SourceSize); if (!(_Expr_val)) { (*_errno()) = 34; _invalid_parameter_noinfo(); return 34; } };

            
            return 22;
        }
        memcpy(_Destination, _Source, _SourceSize);
        return 0;
    }

    
    static __inline errno_t __cdecl memmove_s(
          void*       const _Destination,
                                                              rsize_t     const _DestinationSize,
                                 void const* const _Source,
                                                              rsize_t     const _SourceSize
        )
    {
        if (_SourceSize == 0)
        {
            return 0;
        }

        { int _Expr_val=!!(_Destination != ((void *)0)); if (!(_Expr_val)) { (*_errno()) = 22; _invalid_parameter_noinfo(); return 22; } };
        { int _Expr_val=!!(_Source != ((void *)0)); if (!(_Expr_val)) { (*_errno()) = 22; _invalid_parameter_noinfo(); return 22; } };
        { int _Expr_val=!!(_DestinationSize >= _SourceSize); if (!(_Expr_val)) { (*_errno()) = 34; _invalid_parameter_noinfo(); return 34; } };

        memmove(_Destination, _Source, _SourceSize);
        return 0;
    }






#pragma warning(pop) 




#pragma warning(push)
#pragma warning(disable: 4324  4514 4574 4710 4793 4820 4995 4996 28719 28726 28727 )








 
 int __cdecl _memicmp(
      void const* _Buf1,
      void const* _Buf2,
                             size_t      _Size
    );

 
 int __cdecl _memicmp_l(
      void const* _Buf1,
      void const* _Buf2,
                             size_t      _Size,
                         _locale_t   _Locale
    );





    














    




















    
     void* __cdecl memccpy(
          void*       _Dst,
            void const* _Src,
                                   int         _Val,
                                   size_t      _Size
        );

      
     int __cdecl memicmp(
          void const* _Buf1,
          void const* _Buf2,
                                 size_t      _Size
        );


























#pragma warning(pop) 










#pragma once




#pragma warning(push)
#pragma warning(disable: 4324  4514 4574 4710 4793 4820 4995 4996 28719 28726 28727 )















    
     errno_t __cdecl wcscat_s(
          wchar_t* _Destination,
          rsize_t _SizeInWords,
          wchar_t const* _Source
        );

    
     errno_t __cdecl wcscpy_s(
          wchar_t* _Destination,
          rsize_t _SizeInWords,
          wchar_t const* _Source
        );

    
     errno_t __cdecl wcsncat_s(
          wchar_t*       _Destination,
                                     rsize_t        _SizeInWords,
               wchar_t const* _Source,
                                     rsize_t        _MaxCount
        );

    
     errno_t __cdecl wcsncpy_s(
          wchar_t*       _Destination,
                                  rsize_t        _SizeInWords,
            wchar_t const* _Source,
                                  rsize_t        _MaxCount
        );

     
     wchar_t* __cdecl wcstok_s(
                          wchar_t*       _String,
                                 wchar_t const* _Delimiter,
            wchar_t**      _Context
        );















 
  wchar_t* __cdecl _wcsdup(
      wchar_t const* _String
    );










    


 
 int __cdecl wcscmp(
      wchar_t const* _String1,
      wchar_t const* _String2
    );





 
 size_t __cdecl wcscspn(
      wchar_t const* _String,
      wchar_t const* _Control
    );

 
 size_t __cdecl wcslen(
      wchar_t const* _String
    );

 


 size_t __cdecl wcsnlen(
      wchar_t const* _Source,
                            size_t         _MaxCount
    );



     
    
    
    static __inline size_t __cdecl wcsnlen_s(
          wchar_t const* _Source,
                                size_t         _MaxCount
        )
    {
        return (_Source == 0) ? 0 : wcsnlen(_Source, _MaxCount);
    }







 
 int __cdecl wcsncmp(
      wchar_t const* _String1,
      wchar_t const* _String2,
                            size_t         _MaxCount
    );





 
 wchar_t * __cdecl wcspbrk(
      wchar_t const* _String,
      wchar_t const* _Control
    );

 
 size_t __cdecl wcsspn(
      wchar_t const* _String,
      wchar_t const* _Control
    );

  
 wchar_t* __cdecl wcstok(
                          wchar_t*       _String,
                                 wchar_t const* _Delimiter,
        wchar_t**      _Context
    );



    


        



    

      
    static __inline wchar_t* __cdecl _wcstok(
          wchar_t*       const _String,
                 wchar_t const* const _Delimiter
        )
    {
        return wcstok(_String, _Delimiter, 0);
    }

    



    














 
  
 wchar_t* __cdecl _wcserror(
      int _ErrorNumber
    );


 errno_t __cdecl _wcserror_s(
      wchar_t* _Buffer,
                                  size_t   _SizeInWords,
                                  int      _ErrorNumber
    );



 
 
  
 wchar_t* __cdecl __wcserror(
      wchar_t const* _String
    );

  errno_t __cdecl __wcserror_s(
      wchar_t*       _Buffer,
                                  size_t         _SizeInWords,
                                wchar_t const* _ErrorMessage
    );



   int __cdecl _wcsicmp(
      wchar_t const* _String1,
      wchar_t const* _String2
    );

   int __cdecl _wcsicmp_l(
        wchar_t const* _String1,
        wchar_t const* _String2,
      _locale_t      _Locale
    );

   int __cdecl _wcsnicmp(
      wchar_t const* _String1,
      wchar_t const* _String2,
                            size_t         _MaxCount
    );

   int __cdecl _wcsnicmp_l(
      wchar_t const* _String1,
      wchar_t const* _String2,
                            size_t         _MaxCount,
                        _locale_t      _Locale
    );

  errno_t __cdecl _wcsnset_s(
      wchar_t* _Destination,
                                 size_t   _SizeInWords,
                                 wchar_t  _Value,
                                 size_t   _MaxCount
    );





 wchar_t* __cdecl _wcsrev(
      wchar_t* _String
    );

  errno_t __cdecl _wcsset_s(
      wchar_t* _Destination,
                                 size_t   _SizeInWords,
                                 wchar_t  _Value
    );





  errno_t __cdecl _wcslwr_s(
      wchar_t* _String,
                                 size_t   _SizeInWords
    );






 errno_t __cdecl _wcslwr_s_l(
      wchar_t*  _String,
                                 size_t    _SizeInWords,
                             _locale_t _Locale
    );






 errno_t __cdecl _wcsupr_s(
      wchar_t* _String,
                          size_t   _Size
    );






 errno_t __cdecl _wcsupr_s_l(
      wchar_t*  _String,
                          size_t    _Size,
                      _locale_t _Locale
    );





 

 size_t __cdecl wcsxfrm(
        wchar_t*       _Destination,
                                         wchar_t const* _Source,
                size_t         _MaxCount
    );

 

 size_t __cdecl _wcsxfrm_l(
        wchar_t*       _Destination,
                                         wchar_t const* _Source,
                size_t         _MaxCount,
                                       _locale_t      _Locale
    );

 
 int __cdecl wcscoll(
      wchar_t const* _String1,
      wchar_t const* _String2
    );

 
 int __cdecl _wcscoll_l(
        wchar_t const* _String1,
        wchar_t const* _String2,
      _locale_t      _Locale
    );

 
 int __cdecl _wcsicoll(
      wchar_t const* _String1,
      wchar_t const* _String2
    );

 
 int __cdecl _wcsicoll_l(
        wchar_t const* _String1,
        wchar_t const* _String2,
      _locale_t      _Locale
    );

 
 int __cdecl _wcsncoll(
      wchar_t const* _String1,
      wchar_t const* _String2,
                            size_t         _MaxCount
    );

 
 int __cdecl _wcsncoll_l(
      wchar_t const* _String1,
      wchar_t const* _String2,
                            size_t         _MaxCount,
                        _locale_t      _Locale
    );

 
 int __cdecl _wcsnicoll(
      wchar_t const* _String1,
      wchar_t const* _String2,
                            size_t         _MaxCount
    );

 
 int __cdecl _wcsnicoll_l(
      wchar_t const* _String1,
      wchar_t const* _String2,
                            size_t         _MaxCount,
                        _locale_t      _Locale
    );
















































    




      
     wchar_t* __cdecl wcsdup(
          wchar_t const* _String
        );

    



    
    

      
     int __cdecl wcsicmp(
          wchar_t const* _String1,
          wchar_t const* _String2
        );

      
     int __cdecl wcsnicmp(
          wchar_t const* _String1,
          wchar_t const* _String2,
                                size_t         _MaxCount
        );

    
     
     wchar_t* __cdecl wcsnset(
          wchar_t* _String,
                                  wchar_t  _Value,
                                  size_t   _MaxCount
        );

    
     
     wchar_t* __cdecl wcsrev(
          wchar_t* _String
        );

    
     
     wchar_t* __cdecl wcsset(
          wchar_t* _String,
               wchar_t  _Value
        );

    
     
     wchar_t* __cdecl wcslwr(
          wchar_t* _String
        );

    
     
     wchar_t* __cdecl wcsupr(
          wchar_t* _String
        );

      
     int __cdecl wcsicoll(
          wchar_t const* _String1,
          wchar_t const* _String2
        );









#pragma warning(pop) 





#pragma warning(push)
#pragma warning(disable: 4324  4514 4574 4710 4793 4820 4995 4996 28719 28726 28727 )










    
     errno_t __cdecl strcpy_s(
          char*       _Destination,
                                  rsize_t     _SizeInBytes,
                                char const* _Source
        );

    
     errno_t __cdecl strcat_s(
          char*       _Destination,
                                     rsize_t     _SizeInBytes,
                                   char const* _Source
        );

    
     errno_t __cdecl strerror_s(
          char*  _Buffer,
                                  size_t _SizeInBytes,
                                  int    _ErrorNumber);

    
     errno_t __cdecl strncat_s(
          char*       _Destination,
                                     rsize_t     _SizeInBytes,
               char const* _Source,
                                     rsize_t     _MaxCount
        );

    
     errno_t __cdecl strncpy_s(
          char*       _Destination,
                                  rsize_t     _SizeInBytes,
            char const* _Source,
                                  rsize_t     _MaxCount
        );

     
     char*  __cdecl strtok_s(
                          char*       _String,
                                 char const* _Delimiter,
            char**      _Context
        );



 void* __cdecl _memccpy(
      void*       _Dst,
                                   void const* _Src,
                                   int         _Val,
                                   size_t      _MaxCount
    );





    



 
int __cdecl strcmp(
      char const* _Str1,
      char const* _Str2
    );

 
 int __cdecl _strcmpi(
      char const* _String1,
      char const* _String2
    );

 
 int __cdecl strcoll(
      char const* _String1,
      char const* _String2
    );

 
 int __cdecl _strcoll_l(
        char const* _String1,
        char const* _String2,
      _locale_t   _Locale
    );





 
 size_t __cdecl strcspn(
      char const* _Str,
      char const* _Control
    );






 
  char* __cdecl _strdup(
      char const* _Source
    );





 
 
  
 char*  __cdecl _strerror(
      char const* _ErrorMessage
    );


 errno_t __cdecl _strerror_s(
      char*       _Buffer,
                              size_t      _SizeInBytes,
                        char const* _ErrorMessage
    );



 
  
 char* __cdecl strerror(
      int _ErrorMessage
    );



 
 int __cdecl _stricmp(
      char const* _String1,
      char const* _String2
    );

 
 int __cdecl _stricoll(
      char const* _String1,
      char const* _String2
    );

 
 int __cdecl _stricoll_l(
        char const* _String1,
        char const* _String2,
      _locale_t   _Locale
    );

 
 int __cdecl _stricmp_l(
        char const* _String1,
        char const* _String2,
      _locale_t   _Locale
    );

 
size_t __cdecl strlen(
      char const* _Str
    );


 errno_t __cdecl _strlwr_s(
      char*  _String,
                          size_t _Size
    );






 errno_t __cdecl _strlwr_s_l(
      char*     _String,
                          size_t    _Size,
                      _locale_t _Locale
    );









 
 int __cdecl strncmp(
      char const* _Str1,
      char const* _Str2,
                            size_t      _MaxCount
    );

 
 int __cdecl _strnicmp(
      char const* _String1,
      char const* _String2,
                            size_t      _MaxCount
    );

 
 int __cdecl _strnicmp_l(
      char const* _String1,
      char const* _String2,
                            size_t      _MaxCount,
                        _locale_t   _Locale
    );

 
 int __cdecl _strnicoll(
      char const* _String1,
      char const* _String2,
                            size_t      _MaxCount
    );

 
 int __cdecl _strnicoll_l(
      char const* _String1,
      char const* _String2,
                            size_t      _MaxCount,
                        _locale_t   _Locale
    );

 
 int __cdecl _strncoll(
      char const* _String1,
      char const* _String2,
                            size_t      _MaxCount
    );

 
 int __cdecl _strncoll_l(
      char const* _String1,
      char const* _String2,
                            size_t      _MaxCount,
                        _locale_t   _Locale
    );

 size_t __cdecl __strncnt(
      char const* _String,
                         size_t      _Count
    );





 


 size_t __cdecl strnlen(
      char const* _String,
                            size_t      _MaxCount
    );



     
    
    
    static __inline size_t __cdecl strnlen_s(
          char const* _String,
                                size_t      _MaxCount
        )
    {
        return _String == 0 ? 0 : strnlen(_String, _MaxCount);
    }




 errno_t __cdecl _strnset_s(
      char*  _String,
                                 size_t _SizeInBytes,
                                 int    _Value,
                                 size_t _MaxCount
    );





 
 char * __cdecl strpbrk(
      char const* _Str,
      char const* _Control
    );

 char* __cdecl _strrev(
      char* _Str
    );


 errno_t __cdecl _strset_s(
      char*  _Destination,
                                     size_t _DestinationSize,
                                     int    _Value
    );





 
 size_t __cdecl strspn(
      char const* _Str,
      char const* _Control
    );

  
 char* __cdecl strtok(
      char*       _String,
             char const* _Delimiter
    );


 errno_t __cdecl _strupr_s(
      char*  _String,
                          size_t _Size
    );






 errno_t __cdecl _strupr_s_l(
      char*     _String,
                          size_t    _Size,
                      _locale_t _Locale
    );





 

 size_t __cdecl strxfrm(
        char*       _Destination,
                                         char const* _Source,
                 size_t      _MaxCount
    );

 

 size_t __cdecl _strxfrm_l(
        char*       _Destination,
                                         char const* _Source,
                 size_t      _MaxCount,
                                       _locale_t   _Locale
    );




































    
    
      
     char* __cdecl strdup(
          char const* _String
        );
    

    
      
     int __cdecl strcmpi(
          char const* _String1,
          char const* _String2
        );

      
     int __cdecl stricmp(
          char const* _String1,
          char const* _String2
        );

    
     char* __cdecl strlwr(
          char* _String
        );

      
     int __cdecl strnicmp(
          char const* _String1,
          char const* _String2,
                                size_t      _MaxCount
        );

    
     char* __cdecl strnset(
          char*  _String,
                                  int    _Value,
                                  size_t _MaxCount
        );

    
     char* __cdecl strrev(
          char* _String
        );

    
    char* __cdecl strset(
          char* _String,
               int   _Value);

    
     char* __cdecl strupr(
          char* _String
        );







#pragma warning(pop) 











#pragma once













#pragma once



#pragma warning(push)
#pragma warning(disable: 4324  4514 4574 4710 4793 4820 4995 4996 28719 28726 28727 )










































     
  
void* __cdecl _calloc_base(
      size_t _Count,
      size_t _Size
    );

     
    
void* __cdecl calloc(
       size_t _Count,
       size_t _Size
    );

 
 int __cdecl _callnewh(
      size_t _Size
    );

     
  
void* __cdecl _expand(
                void*  _Block,
       size_t _Size
    );


void __cdecl _free_base(
        void* _Block
    );

 
void __cdecl free(
        void* _Block
    );

     
  
void* __cdecl _malloc_base(
      size_t _Size
    );

     
    
void* __cdecl malloc(
       size_t _Size
    );

 

size_t __cdecl _msize_base(
      void* _Block
    ) ;

 
 
size_t __cdecl _msize(
      void* _Block
    );

       
  
void* __cdecl _realloc_base(
         void*  _Block,
                                 size_t _Size
    );

       
   
void* __cdecl realloc(
        void*  _Block,
              size_t _Size
    );

       
  
void* __cdecl _recalloc_base(
        void*  _Block,
                                size_t _Count,
                                size_t _Size
    );

       
  
void* __cdecl _recalloc(
        void*  _Block,
              size_t _Count,
              size_t _Size
    );


void __cdecl _aligned_free(
        void* _Block
    );

     
  
void* __cdecl _aligned_malloc(
       size_t _Size,
                         size_t _Alignment
    );

     
  
void* __cdecl _aligned_offset_malloc(
       size_t _Size,
                         size_t _Alignment,
                         size_t _Offset
    );

 

size_t __cdecl _aligned_msize(
      void*  _Block,
               size_t _Alignment,
               size_t _Offset
    );

       
  
void* __cdecl _aligned_offset_realloc(
        void*  _Block,
              size_t _Size,
                                size_t _Alignment,
                                size_t _Offset
    );

       
  
void* __cdecl _aligned_offset_recalloc(
        void*  _Block,
              size_t _Count,
              size_t _Size,
                                size_t _Alignment,
                                size_t _Offset
    );

       
  
void* __cdecl _aligned_realloc(
        void*  _Block,
              size_t _Size,
                                size_t _Alignment
    );

       
  
void* __cdecl _aligned_recalloc(
        void*  _Block,
              size_t _Count,
              size_t _Size,
                                size_t _Alignment
    );
























#pragma warning(pop) 












#pragma once










#pragma once





#pragma warning(push)
#pragma warning(disable: 4324  4514 4574 4710 4793 4820 4995 4996 28719 28726 28727 )



















     int* __cdecl _errno(void);
    

     errno_t __cdecl _set_errno(  int _Value);
     errno_t __cdecl _get_errno(  int* _Value);






    


        
    




 extern unsigned long  __cdecl __threadid(void);

 extern uintptr_t __cdecl __threadhandle(void);





#pragma warning(pop) 



#pragma warning(push)
#pragma warning(disable: 4324  4514 4574 4710 4793 4820 4995 4996 28719 28726 28727 )





    typedef int (__cdecl* _CoreCrtSecureSearchSortCompareFunction)(void*, void const*, void const*);
    typedef int (__cdecl* _CoreCrtNonSecureSearchSortCompareFunction)(void const*, void const*);




     
     void* __cdecl bsearch_s(
                                                        void const* _Key,
          void const* _Base,
                                                        rsize_t     _NumOfElements,
                                                        rsize_t     _SizeOfElements,
                            _CoreCrtSecureSearchSortCompareFunction _CompareFunction,
                                                    void*       _Context
        );

     void __cdecl qsort_s(
          void*   _Base,
                                                             rsize_t _NumOfElements,
                                                             rsize_t _SizeOfElements,
                             _CoreCrtSecureSearchSortCompareFunction _CompareFunction,
                                                         void*   _Context
        );





 
 void* __cdecl bsearch(
                                                    void const* _Key,
      void const* _Base,
                                                    size_t      _NumOfElements,
                                                    size_t      _SizeOfElements,
                     _CoreCrtNonSecureSearchSortCompareFunction _CompareFunction
    );

 void __cdecl qsort(
      void*  _Base,
                                                         size_t _NumOfElements,
                                                         size_t _SizeOfElements,
                     _CoreCrtNonSecureSearchSortCompareFunction _CompareFunction
    );

 
 void* __cdecl _lfind_s(
                                                       void const*   _Key,
      void const*   _Base,
                                                    unsigned int* _NumOfElements,
                                                       size_t        _SizeOfElements,
                             _CoreCrtSecureSearchSortCompareFunction _CompareFunction,
                                                       void*         _Context
    );

 
 void* __cdecl _lfind(
                                                       void const*   _Key,
      void const*   _Base,
                                                    unsigned int* _NumOfElements,
                                                       unsigned int  _SizeOfElements,
                          _CoreCrtNonSecureSearchSortCompareFunction _CompareFunction
    );

 
 void* __cdecl _lsearch_s(
                                                             void const*   _Key,
      void*         _Base,
                                                          unsigned int* _NumOfElements,
                                                             size_t        _SizeOfElements,
                                   _CoreCrtSecureSearchSortCompareFunction _CompareFunction,
                                                             void*         _Context
    );

 
 void* __cdecl _lsearch(
                                                             void const*   _Key,
      void*         _Base,
                                                          unsigned int* _NumOfElements,
                                                             unsigned int  _SizeOfElements,
                                _CoreCrtNonSecureSearchSortCompareFunction _CompareFunction
    );


























































































      
     void* __cdecl lfind(
                                                           void const*   _Key,
          void const*   _Base,
                                                        unsigned int* _NumOfElements,
                                                           unsigned int  _SizeOfElements,
                              _CoreCrtNonSecureSearchSortCompareFunction _CompareFunction
        );

      
     void* __cdecl lsearch(
                                                                void const*   _Key,
          void*         _Base,
                                                             unsigned int* _NumOfElements,
                                                                unsigned int  _SizeOfElements,
                                   _CoreCrtNonSecureSearchSortCompareFunction _CompareFunction
        );







#pragma warning(pop) 










#pragma once



#pragma warning(push)
#pragma warning(disable: 4324  4514 4574 4710 4793 4820 4995 4996 28719 28726 28727 )





































     
    
     errno_t __cdecl _itow_s(
                                  int      _Value,
          wchar_t* _Buffer,
                                  size_t   _BufferCount,
                                  int      _Radix
        );

    

    

     
    
     errno_t __cdecl _ltow_s(
                                  long     _Value,
          wchar_t* _Buffer,
                                  size_t   _BufferCount,
                                  int      _Radix
        );

    

    

    
     errno_t __cdecl _ultow_s(
                                  unsigned long _Value,
          wchar_t*      _Buffer,
                                  size_t        _BufferCount,
                                  int           _Radix
        );

    

    

     
     double __cdecl wcstod(
                            wchar_t const* _String,
            wchar_t**      _EndPtr
        );

     
     double __cdecl _wcstod_l(
                            wchar_t const* _String,
            wchar_t**      _EndPtr,
                          _locale_t      _Locale
        );

     
     long __cdecl wcstol(
                            wchar_t const* _String,
            wchar_t**      _EndPtr,
                              int            _Radix
        );

     
     long __cdecl _wcstol_l(
                            wchar_t const* _String,
            wchar_t**      _EndPtr,
                              int            _Radix,
                          _locale_t      _Locale
        );

     
     long long __cdecl wcstoll(
                            wchar_t const* _String,
            wchar_t**      _EndPtr,
                              int            _Radix
        );

     
     long long __cdecl _wcstoll_l(
                            wchar_t const* _String,
            wchar_t**      _EndPtr,
                              int            _Radix,
                          _locale_t      _Locale
        );

     
     unsigned long __cdecl wcstoul(
                            wchar_t const* _String,
            wchar_t**      _EndPtr,
                              int            _Radix
        );

     
     unsigned long __cdecl _wcstoul_l(
                            wchar_t const* _String,
            wchar_t**      _EndPtr,
                              int            _Radix,
                          _locale_t      _Locale
        );

     
     unsigned long long __cdecl wcstoull(
                            wchar_t const* _String,
            wchar_t**      _EndPtr,
                              int            _Radix
        );

     
     unsigned long long __cdecl _wcstoull_l(
                            wchar_t const* _String,
            wchar_t**      _EndPtr,
                              int            _Radix,
                          _locale_t      _Locale
        );

     
     long double __cdecl wcstold(
                            wchar_t const* _String,
            wchar_t**      _EndPtr
        );

     
     long double __cdecl _wcstold_l(
                            wchar_t const* _String,
            wchar_t**      _EndPtr,
                          _locale_t      _Locale
        );

     
     float __cdecl wcstof(
                            wchar_t const* _String,
            wchar_t**      _EndPtr
        );

     
     float __cdecl _wcstof_l(
                            wchar_t const* _String,
            wchar_t**      _EndPtr,
                          _locale_t      _Locale
        );

     
     double __cdecl _wtof(
          wchar_t const* _String
        );

     
     double __cdecl _wtof_l(
            wchar_t const* _String,
          _locale_t      _Locale
        );

     
     int __cdecl _wtoi(
          wchar_t const* _String
        );

     
     int __cdecl _wtoi_l(
            wchar_t const* _String,
          _locale_t      _Locale
        );

     
     long __cdecl _wtol(
          wchar_t const* _String
        );

     
     long __cdecl _wtol_l(
            wchar_t const* _String,
          _locale_t      _Locale
        );

     
     long long __cdecl _wtoll(
          wchar_t const* _String
        );

     
     long long __cdecl _wtoll_l(
            wchar_t const* _String,
          _locale_t      _Locale
        );

    
     errno_t __cdecl _i64tow_s(
                                  __int64  _Value,
          wchar_t* _Buffer,
                                  size_t   _BufferCount,
                                  int      _Radix
        );

    
     wchar_t* __cdecl _i64tow(
                            __int64  _Value,
            wchar_t* _Buffer,
                            int      _Radix
        );

    
     errno_t __cdecl _ui64tow_s(
                                  unsigned __int64 _Value,
          wchar_t*         _Buffer,
                                  size_t           _BufferCount,
                                  int              _Radix
        );

    
     wchar_t* __cdecl _ui64tow(
                            unsigned __int64 _Value,
            wchar_t*         _Buffer,
                            int              _Radix
        );

     
     __int64 __cdecl _wtoi64(
          wchar_t const* _String
        );

     
     __int64 __cdecl _wtoi64_l(
            wchar_t const* _String,
          _locale_t      _Locale
        );

     
     __int64 __cdecl _wcstoi64(
                            wchar_t const* _String,
            wchar_t**      _EndPtr,
                              int            _Radix
        );

     
     __int64 __cdecl _wcstoi64_l(
                            wchar_t const* _String,
            wchar_t**      _EndPtr,
                              int            _Radix,
                          _locale_t      _Locale
        );

     
     unsigned __int64 __cdecl _wcstoui64(
                            wchar_t const* _String,
            wchar_t**      _EndPtr,
                              int            _Radix
        );

     
     unsigned __int64 __cdecl _wcstoui64_l(
                            wchar_t const* _String,
            wchar_t**      _EndPtr,
                              int            _Radix,
                          _locale_t      _Locale
        );

    
    

     
     
      wchar_t* __cdecl _wfullpath(
          wchar_t*       _Buffer,
                                    wchar_t const* _Path,
                                      size_t         _BufferCount
        );

    

    
     errno_t __cdecl _wmakepath_s(
          wchar_t*       _Buffer,
                                  size_t         _BufferCount,
                            wchar_t const* _Drive,
                            wchar_t const* _Dir,
                            wchar_t const* _Filename,
                            wchar_t const* _Ext
        );

    



     void __cdecl _wperror(
          wchar_t const* _ErrorMessage
        );

    
     void __cdecl _wsplitpath(
                            wchar_t const* _FullPath,
            wchar_t*       _Drive,
            wchar_t*       _Dir,
            wchar_t*       _Filename,
            wchar_t*       _Ext
        );

     errno_t __cdecl _wsplitpath_s(
                                      wchar_t const* _FullPath,
             wchar_t*       _Drive,
                                        size_t         _DriveCount,
               wchar_t*       _Dir,
                                        size_t         _DirCount,
          wchar_t*       _Filename,
                                        size_t         _FilenameCount,
               wchar_t*       _Ext,
                                        size_t         _ExtCount
        );

    

        
        

        
         errno_t __cdecl _wdupenv_s(
                wchar_t**      _Buffer,
                                                                                size_t*        _BufferCount,
                                                                                   wchar_t const* _VarName
            );

        

          
         wchar_t* __cdecl _wgetenv(
              wchar_t const* _VarName
            );

         
        
         errno_t __cdecl _wgetenv_s(
                                         size_t*        _RequiredCount,
              wchar_t*       _Buffer,
                                          size_t         _BufferCount,
                                        wchar_t const* _VarName
            );

        

         
         int __cdecl _wputenv(
              wchar_t const* _EnvString
            );

        
         errno_t __cdecl _wputenv_s(
              wchar_t const* _Name,
              wchar_t const* _Value
            );

         errno_t __cdecl _wsearchenv_s(
                                    wchar_t const* _Filename,
                                    wchar_t const* _VarName,
              wchar_t*       _Buffer,
                                      size_t         _BufferCount
            );

        

        

         int __cdecl _wsystem(
              wchar_t const* _Command
            );







#pragma warning(pop) 









#pragma once




#pragma warning(push)
#pragma warning(disable:   4514 4820 )









    
    




































    
    


        
    



    




#pragma warning(pop) 


#pragma warning(push)
#pragma warning(disable: 4324  4514 4574 4710 4793 4820 4995 4996 28719 28726 28727 )







    










 void __cdecl _swab(
        char* _Buf1,
        char* _Buf2,
                                                                  int   _SizeInBytes
    );













     __declspec(noreturn) void __cdecl exit(  int _Code);
     __declspec(noreturn) void __cdecl _exit(  int _Code);
     __declspec(noreturn) void __cdecl _Exit(  int _Code);
     __declspec(noreturn) void __cdecl quick_exit(  int _Code);
     __declspec(noreturn) void __cdecl abort(void);






 unsigned int __cdecl _set_abort_behavior(
      unsigned int _Flags,
      unsigned int _Mask
    );




    

    typedef int (__cdecl* _onexit_t)(void);
    





    
    


























































    int       __cdecl atexit(void (__cdecl*)(void));
    _onexit_t __cdecl _onexit(  _onexit_t _Func);


int __cdecl at_quick_exit(void (__cdecl*)(void));









    
    typedef void (__cdecl* _purecall_handler)(void);

    
    typedef void (__cdecl* _invalid_parameter_handler)(
        wchar_t const*,
        wchar_t const*,
        wchar_t const*,
        unsigned int,
        uintptr_t
        );

    
     _purecall_handler __cdecl _set_purecall_handler(
          _purecall_handler _Handler
        );

     _purecall_handler __cdecl _get_purecall_handler(void);

    
     _invalid_parameter_handler __cdecl _set_invalid_parameter_handler(
          _invalid_parameter_handler _Handler
        );

     _invalid_parameter_handler __cdecl _get_invalid_parameter_handler(void);

     _invalid_parameter_handler __cdecl _set_thread_local_invalid_parameter_handler(
          _invalid_parameter_handler _Handler
        );

     _invalid_parameter_handler __cdecl _get_thread_local_invalid_parameter_handler(void);























  int __cdecl _set_error_mode(  int _Mode);




     int* __cdecl _errno(void);
    

     errno_t __cdecl _set_errno(  int _Value);
     errno_t __cdecl _get_errno(  int* _Value);

     unsigned long* __cdecl __doserrno(void);
    

     errno_t __cdecl _set_doserrno(  unsigned long _Value);
     errno_t __cdecl _get_doserrno(  unsigned long * _Value);

    
     
    

     
    

     void __cdecl perror(  char const* _ErrMsg);
















    
    
    


 
 errno_t __cdecl _get_pgmptr (  char**    _Value);

 
 errno_t __cdecl _get_wpgmptr(  wchar_t** _Value);

 errno_t __cdecl _set_fmode  (               int       _Mode );

 errno_t __cdecl _get_fmode  (              int*      _PMode);








typedef struct _div_t
{
    int quot;
    int rem;
} div_t;

typedef struct _ldiv_t
{
    long quot;
    long rem;
} ldiv_t;

typedef struct _lldiv_t
{
    long long quot;
    long long rem;
} lldiv_t;

  int       __cdecl abs   (  int       _Number);
  long      __cdecl labs  (  long      _Number);
  long long __cdecl llabs (  long long _Number);
  __int64   __cdecl _abs64(  __int64   _Number);

  unsigned short   __cdecl _byteswap_ushort(  unsigned short   _Number);
  unsigned long    __cdecl _byteswap_ulong (  unsigned long    _Number);
  unsigned __int64 __cdecl _byteswap_uint64(  unsigned __int64 _Number);

   div_t   __cdecl div  (  int       _Numerator,   int       _Denominator);
   ldiv_t  __cdecl ldiv (  long      _Numerator,   long      _Denominator);
   lldiv_t __cdecl lldiv(  long long _Numerator,   long long _Denominator);



#pragma warning(push)
#pragma warning(disable: 6540)

unsigned int __cdecl _rotl(
      unsigned int _Value,
      int          _Shift
    );

 
unsigned long __cdecl _lrotl(
      unsigned long _Value,
      int           _Shift
    );

unsigned __int64 __cdecl _rotl64(
      unsigned __int64 _Value,
      int              _Shift
    );

unsigned int __cdecl _rotr(
      unsigned int _Value,
      int          _Shift
    );

 
unsigned long __cdecl _lrotr(
      unsigned long _Value,
      int           _Shift
    );

unsigned __int64 __cdecl _rotr64(
      unsigned __int64 _Value,
      int              _Shift
    );

#pragma warning(pop)






 void __cdecl srand(  unsigned int _Seed);

   int __cdecl rand(void);









































    #pragma pack(push, 4)
    typedef struct
    {
        unsigned char ld[10];
    } _LDOUBLE;
    #pragma pack(pop)

    













typedef struct
{
    double x;
} _CRT_DOUBLE;

typedef struct
{
    float f;
} _CRT_FLOAT;





typedef struct
{
    long double x;
} _LONGDOUBLE;



#pragma pack(push, 4)
typedef struct
{
    unsigned char ld12[12];
} _LDBL12;
#pragma pack(pop)








                      double    __cdecl atof   (  char const* _String);
    int       __cdecl atoi   (  char const* _String);
                      long      __cdecl atol   (  char const* _String);
                      long long __cdecl atoll  (  char const* _String);
                      __int64   __cdecl _atoi64(  char const* _String);

   double    __cdecl _atof_l  (  char const* _String,   _locale_t _Locale);
   int       __cdecl _atoi_l  (  char const* _String,   _locale_t _Locale);
   long      __cdecl _atol_l  (  char const* _String,   _locale_t _Locale);
   long long __cdecl _atoll_l (  char const* _String,   _locale_t _Locale);
   __int64   __cdecl _atoi64_l(  char const* _String,   _locale_t _Locale);

   int __cdecl _atoflt (  _CRT_FLOAT*  _Result,   char const* _String);
   int __cdecl _atodbl (  _CRT_DOUBLE* _Result,   char*       _String);
   int __cdecl _atoldbl(  _LDOUBLE*    _Result,   char*       _String);

 
 int __cdecl _atoflt_l(
         _CRT_FLOAT* _Result,
        char const* _String,
      _locale_t   _Locale
    );

 
 int __cdecl _atodbl_l(
         _CRT_DOUBLE* _Result,
        char*        _String,
      _locale_t    _Locale
    );


 
 int __cdecl _atoldbl_l(
         _LDOUBLE* _Result,
        char*     _String,
      _locale_t _Locale
    );

 
 float __cdecl strtof(
                        char const* _String,
        char**      _EndPtr
    );

 
 float __cdecl _strtof_l(
                        char const* _String,
        char**      _EndPtr,
                      _locale_t   _Locale
    );

 
 double __cdecl strtod(
                        char const* _String,
        char**      _EndPtr
    );

 
 double __cdecl _strtod_l(
                        char const* _String,
        char**      _EndPtr,
                      _locale_t   _Locale
    );

 
 long double __cdecl strtold(
                        char const* _String,
        char**      _EndPtr
    );

 
 long double __cdecl _strtold_l(
                        char const* _String,
        char**      _EndPtr,
                      _locale_t   _Locale
    );

 
 long __cdecl strtol(
                        char const* _String,
        char**      _EndPtr,
                          int         _Radix
    );

 
 long __cdecl _strtol_l(
                        char const* _String,
        char**      _EndPtr,
                          int         _Radix,
                      _locale_t   _Locale
    );

 
 long long __cdecl strtoll(
                        char const* _String,
        char**      _EndPtr,
                          int         _Radix
    );

 
 long long __cdecl _strtoll_l(
                        char const* _String,
        char**      _EndPtr,
                          int         _Radix,
                      _locale_t   _Locale
    );

 
 unsigned long __cdecl strtoul(
                        char const* _String,
        char**      _EndPtr,
                          int         _Radix
    );

 
 unsigned long __cdecl _strtoul_l(
                        char const* _String,
        char**      _EndPtr,
                          int         _Radix,
                      _locale_t   _Locale
    );

 
 unsigned long long __cdecl strtoull(
                        char const* _String,
        char**      _EndPtr,
                          int         _Radix
    );

 
 unsigned long long __cdecl _strtoull_l(
                        char const* _String,
        char**      _EndPtr,
                          int         _Radix,
                      _locale_t   _Locale
    );

 
 __int64 __cdecl _strtoi64(
                        char const* _String,
        char**      _EndPtr,
                          int         _Radix
    );

 
 __int64 __cdecl _strtoi64_l(
                        char const* _String,
        char**      _EndPtr,
                          int         _Radix,
                      _locale_t   _Locale
    );

 
 unsigned __int64 __cdecl _strtoui64(
                        char const* _String,
        char**      _EndPtr,
                          int         _Radix
    );

 
 unsigned __int64 __cdecl _strtoui64_l(
                        char const* _String,
        char**      _EndPtr,
                          int         _Radix,
                      _locale_t   _Locale
    );








 

 errno_t __cdecl _itoa_s(
                              int    _Value,
      char*  _Buffer,
                              size_t _BufferCount,
                              int    _Radix
    );





 

 errno_t __cdecl _ltoa_s(
                              long   _Value,
      char*  _Buffer,
                              size_t _BufferCount,
                              int    _Radix
    );





 

 errno_t __cdecl _ultoa_s(
                              unsigned long _Value,
      char*         _Buffer,
                              size_t        _BufferCount,
                              int           _Radix
    );





 

 errno_t __cdecl _i64toa_s(
                              __int64 _Value,
      char*   _Buffer,
                              size_t  _BufferCount,
                              int     _Radix
    );

 

 char* __cdecl _i64toa(
                        __int64 _Value,
        char*   _Buffer,
                        int     _Radix
    );

 

 errno_t __cdecl _ui64toa_s(
                              unsigned __int64 _Value,
      char*            _Buffer,
                              size_t           _BufferCount,
                              int              _Radix
    );


 char* __cdecl _ui64toa(
                        unsigned __int64 _Value,
        char*            _Buffer,
                        int              _Radix
    );













 

 errno_t __cdecl _ecvt_s(
      char* _Buffer,
       size_t                       _BufferCount,
       double                       _Value,
       int                          _DigitCount,
      int*                         _PtDec,
      int*                         _PtSign
    );



  
 char* __cdecl _ecvt(
       double _Value,
       int    _DigitCount,
      int*   _PtDec,
      int*   _PtSign
    );

 

 errno_t __cdecl _fcvt_s(
      char*  _Buffer,
                              size_t _BufferCount,
                              double _Value,
                              int    _FractionalDigitCount,
                             int*   _PtDec,
                             int*   _PtSign
    );



 
  
 char* __cdecl _fcvt(
       double _Value,
       int    _FractionalDigitCount,
      int*   _PtDec,
      int*   _PtSign
    );

 
 errno_t __cdecl _gcvt_s(
      char*  _Buffer,
                              size_t _BufferCount,
                              double _Value,
                              int    _DigitCount
    );




 char* __cdecl _gcvt(
                        double _Value,
                        int    _DigitCount,
        char*  _Buffer
    );











    


        
    

    


        
    

     
     int __cdecl ___mb_cur_max_func(void);

     
     int __cdecl ___mb_cur_max_l_func(_locale_t _Locale);




 
 int __cdecl mblen(
        char const* _Ch,
                                             size_t      _MaxCount
    );

 
 int __cdecl _mblen_l(
        char const* _Ch,
                                             size_t      _MaxCount,
                                         _locale_t   _Locale
    );

 
 
 size_t __cdecl _mbstrlen(
      char const* _String
    );

 
 
 size_t __cdecl _mbstrlen_l(
        char const* _String,
      _locale_t   _Locale
    );

 
 
 size_t __cdecl _mbstrnlen(
      char const* _String,
        size_t      _MaxCount
    );

 
 
 size_t __cdecl _mbstrnlen_l(
        char const* _String,
          size_t      _MaxCount,
      _locale_t   _Locale
    );

 
 int __cdecl mbtowc(
                      wchar_t*    _DstCh,
      char const* _SrcCh,
                                      size_t      _SrcSizeInBytes
    );

 
 int __cdecl _mbtowc_l(
                      wchar_t*    _DstCh,
      char const* _SrcCh,
                                      size_t      _SrcSizeInBytes,
                                  _locale_t   _Locale
    );


 errno_t __cdecl mbstowcs_s(
                                                      size_t*     _PtNumOfCharConverted,
      wchar_t*    _DstBuf,
                                                           size_t      _SizeInWords,
                                     char const* _SrcBuf,
                                                           size_t      _MaxCount
    );






 errno_t __cdecl _mbstowcs_s_l(
                                                      size_t*     _PtNumOfCharConverted,
      wchar_t*    _DstBuf,
                                                           size_t      _SizeInWords,
                                     char const* _SrcBuf,
                                                           size_t      _MaxCount,
                                                       _locale_t   _Locale
    );









 int __cdecl wctomb(
      char*   _MbCh,
                                wchar_t _WCh
    );


 int __cdecl _wctomb_l(
        char*     _MbCh,
                          wchar_t   _WCh,
                      _locale_t _Locale
    );



    
     errno_t __cdecl wctomb_s(
                                                         int*    _SizeConverted,
          char*   _MbCh,
                                                              rsize_t _SizeInBytes,
                                                              wchar_t _WCh
        );




 errno_t __cdecl _wctomb_s_l(
                             int*     _SizeConverted,
      char*     _MbCh,
                                  size_t    _SizeInBytes,
                                  wchar_t   _WCh,
                              _locale_t _Locale);


 errno_t __cdecl wcstombs_s(
                                                               size_t*        _PtNumOfCharConverted,
      char*          _Dst,
                                                                    size_t         _DstSizeInBytes,
                                                                  wchar_t const* _Src,
                                                                    size_t         _MaxCountInBytes
    );






 errno_t __cdecl _wcstombs_s_l(
                                                               size_t*        _PtNumOfCharConverted,
      char*          _Dst,
                                                                    size_t         _DstSizeInBytes,
                                                                  wchar_t const* _Src,
                                                                    size_t         _MaxCountInBytes,
                                                                _locale_t      _Locale
    );
























 
 
  char* __cdecl _fullpath(
      char*       _Buffer,
                                char const* _Path,
                                  size_t      _BufferCount
    );




 errno_t __cdecl _makepath_s(
      char*       _Buffer,
                              size_t      _BufferCount,
                        char const* _Drive,
                        char const* _Dir,
                        char const* _Filename,
                        char const* _Ext
    );






 void __cdecl _splitpath(
                        char const* _FullPath,
        char*       _Drive,
        char*       _Dir,
        char*       _Filename,
        char*       _Ext
    );


 errno_t __cdecl _splitpath_s(
                                  char const* _FullPath,
         char*       _Drive,
                                    size_t      _DriveCount,
           char*       _Dir,
                                    size_t      _DirCount,
      char*       _Filename,
                                    size_t      _FilenameCount,
           char*       _Ext,
                                    size_t      _ExtCount
    );






 
 errno_t __cdecl getenv_s(
                                 size_t*     _RequiredCount,
      char*       _Buffer,
                                  rsize_t     _BufferCount,
                                char const* _VarName
    );






 int*       __cdecl __p___argc (void);
 char***    __cdecl __p___argv (void);
 wchar_t*** __cdecl __p___wargv(void);






    
    
    


 char***    __cdecl __p__environ (void);
 wchar_t*** __cdecl __p__wenviron(void);


    








    
    










      
     char* __cdecl getenv(
          char const* _VarName
        );

    

    




    
     errno_t __cdecl _dupenv_s(
            char**      _Buffer,
                                                                            size_t*     _BufferCount,
                                                                               char const* _VarName
        );

    



     int __cdecl system(
          char const* _Command
        );

    
    
    #pragma warning(push)
    #pragma warning(disable: 6540)

     
     int __cdecl _putenv(
          char const* _EnvString
        );

    
     errno_t __cdecl _putenv_s(
          char const* _Name,
          char const* _Value
        );

    #pragma warning(pop)

     errno_t __cdecl _searchenv_s(
                                char const* _Filename,
                                char const* _VarName,
          char*       _Buffer,
                                  size_t      _BufferCount
        );

    

    

    
    
     void __cdecl _seterrormode(
          int _Mode
        );

    
     void __cdecl _beep(
          unsigned _Frequency,
          unsigned _Duration
        );

    
     void __cdecl _sleep(
          unsigned long _Duration
        );











    
        
        
    

    
    

    #pragma warning(push)
    #pragma warning(disable: 4141) 

      
     char* __cdecl ecvt(
           double _Value,
           int    _DigitCount,
          int*   _PtDec,
          int*   _PtSign
        );

      
     char* __cdecl fcvt(
           double _Value,
           int    _FractionalDigitCount,
          int*   _PtDec,
          int*   _PtSign
        );

    
     char* __cdecl gcvt(
                            double _Value,
                            int    _DigitCount,
            char*  _DstBuf
        );

    
     char* __cdecl itoa(
                            int   _Value,
            char* _Buffer,
                            int   _Radix
        );

    
     char* __cdecl ltoa(
                            long  _Value,
            char* _Buffer,
                            int   _Radix
        );


    
     void __cdecl swab(
          char* _Buf1,
          char* _Buf2,
                                     int   _SizeInBytes
        );

    
     char* __cdecl ultoa(
                            unsigned long _Value,
            char*         _Buffer,
                            int           _Radix
        );

    

      
     int __cdecl putenv(
          char const* _EnvString
        );

    #pragma warning(pop)

    _onexit_t __cdecl onexit(  _onexit_t _Func);







#pragma warning(pop) 












#pragma once






#pragma warning(push)
#pragma warning(disable:   4514 4820 )

typedef signed char        int8_t;
typedef short              int16_t;
typedef int                int32_t;
typedef long long          int64_t;
typedef unsigned char      uint8_t;
typedef unsigned short     uint16_t;
typedef unsigned int       uint32_t;
typedef unsigned long long uint64_t;

typedef signed char        int_least8_t;
typedef short              int_least16_t;
typedef int                int_least32_t;
typedef long long          int_least64_t;
typedef unsigned char      uint_least8_t;
typedef unsigned short     uint_least16_t;
typedef unsigned int       uint_least32_t;
typedef unsigned long long uint_least64_t;

typedef signed char        int_fast8_t;
typedef int                int_fast16_t;
typedef int                int_fast32_t;
typedef long long          int_fast64_t;
typedef unsigned char      uint_fast8_t;
typedef unsigned int       uint_fast16_t;
typedef unsigned int       uint_fast32_t;
typedef unsigned long long uint_fast64_t;

typedef long long          intmax_t;
typedef unsigned long long uintmax_t;














































    
    
    








































#pragma warning(pop) 


































  






































































typedef uint8_t ecs_flags8_t;
typedef uint16_t ecs_flags16_t;
typedef uint32_t ecs_flags32_t;
typedef uint64_t ecs_flags64_t;
















typedef int32_t ecs_size_t;


typedef struct ecs_allocator_t ecs_allocator_t;








































    


        
    




































































































































































































































typedef uint64_t ecs_id_t;






typedef ecs_id_t ecs_entity_t;
















typedef struct {
    ecs_id_t *array;    
    int32_t count;      
} ecs_type_t;























typedef struct ecs_world_t ecs_world_t;


typedef struct ecs_stage_t ecs_stage_t;


typedef struct ecs_table_t ecs_table_t;


typedef struct ecs_term_t ecs_term_t;


typedef struct ecs_query_t ecs_query_t;


















typedef struct ecs_observer_t ecs_observer_t;




typedef struct ecs_observable_t ecs_observable_t;





typedef struct ecs_iter_t ecs_iter_t;









typedef struct ecs_ref_t ecs_ref_t;




typedef struct ecs_type_hooks_t ecs_type_hooks_t;




typedef struct ecs_type_info_t ecs_type_info_t;


typedef struct ecs_record_t ecs_record_t;


typedef struct ecs_component_record_t ecs_component_record_t;




















typedef void ecs_poly_t;


typedef struct ecs_mixins_t ecs_mixins_t;


typedef struct ecs_header_t {
    int32_t type;               
    int32_t refcount;           
    ecs_mixins_t *mixins;       
} ecs_header_t;


typedef struct ecs_table_record_t ecs_table_record_t;











typedef struct ecs_vec_t {
    void *array;              
    int32_t count;            
    int32_t size;             




} ecs_vec_t;








__declspec(dllimport)
void ecs_vec_init(
    struct ecs_allocator_t *allocator,
    ecs_vec_t *vec,
    ecs_size_t size,
    int32_t elem_count);









__declspec(dllimport)
void ecs_vec_init_w_dbg_info(
    struct ecs_allocator_t *allocator,
    ecs_vec_t *vec,
    ecs_size_t size,
    int32_t elem_count,
    const char *type_name);
















__declspec(dllimport)
void ecs_vec_init_if(
    ecs_vec_t *vec,
    ecs_size_t size);















__declspec(dllimport)
void ecs_vec_fini(
    struct ecs_allocator_t *allocator,
    ecs_vec_t *vec,
    ecs_size_t size);

















__declspec(dllimport)
ecs_vec_t* ecs_vec_reset(
    struct ecs_allocator_t *allocator,
    ecs_vec_t *vec,
    ecs_size_t size);














__declspec(dllimport)
void ecs_vec_clear(
    ecs_vec_t *vec);








__declspec(dllimport)
void* ecs_vec_append(
    struct ecs_allocator_t *allocator,
    ecs_vec_t *vec,
    ecs_size_t size);

















__declspec(dllimport)
void ecs_vec_remove(
    ecs_vec_t *vec,
    ecs_size_t size,
    int32_t elem);
















__declspec(dllimport)
void ecs_vec_remove_ordered(
    ecs_vec_t *v,
    ecs_size_t size,
    int32_t index);














__declspec(dllimport)
void ecs_vec_remove_last(
    ecs_vec_t *vec);








__declspec(dllimport)
ecs_vec_t ecs_vec_copy(
    struct ecs_allocator_t *allocator,
    const ecs_vec_t *vec,
    ecs_size_t size);
















__declspec(dllimport)
void ecs_vec_reclaim(
    struct ecs_allocator_t *allocator,
    ecs_vec_t *vec,
    ecs_size_t size);

















__declspec(dllimport)
void ecs_vec_set_size(
    struct ecs_allocator_t *allocator,
    ecs_vec_t *vec,
    ecs_size_t size,
    int32_t elem_count);


















__declspec(dllimport)
void ecs_vec_set_min_size(
    struct ecs_allocator_t *allocator,
    ecs_vec_t *vec,
    ecs_size_t size,
    int32_t elem_count);


















__declspec(dllimport)
void ecs_vec_set_min_count(
    struct ecs_allocator_t *allocator,
    ecs_vec_t *vec,
    ecs_size_t size,
    int32_t elem_count);


















__declspec(dllimport)
void ecs_vec_set_min_count_zeromem(
    struct ecs_allocator_t *allocator,
    ecs_vec_t *vec,
    ecs_size_t size,
    int32_t elem_count);


















__declspec(dllimport)
void ecs_vec_set_count(
    struct ecs_allocator_t *allocator,
    ecs_vec_t *vec,
    ecs_size_t size,
    int32_t elem_count);



















__declspec(dllimport)
void ecs_vec_set_count_w_type_info(
    struct ecs_allocator_t *allocator,
    ecs_vec_t *vec,
    ecs_size_t size,
    int32_t elem_count,
    const ecs_type_info_t *ti);









__declspec(dllimport)
void ecs_vec_set_min_count_w_type_info(
    struct ecs_allocator_t *allocator,
    ecs_vec_t *vec,
    ecs_size_t size,
    int32_t elem_count,
    const ecs_type_info_t *ti);









__declspec(dllimport)
void* ecs_vec_grow(
    struct ecs_allocator_t *allocator,
    ecs_vec_t *vec,
    ecs_size_t size,
    int32_t elem_count);
















__declspec(dllimport)
int32_t ecs_vec_count(
    const ecs_vec_t *vec);






__declspec(dllimport)
int32_t ecs_vec_size(
    const ecs_vec_t *vec);








__declspec(dllimport)
void* ecs_vec_get(
    const ecs_vec_t *vec,
    ecs_size_t size,
    int32_t index);
















__declspec(dllimport)
void* ecs_vec_first(
    const ecs_vec_t *vec);
















__declspec(dllimport)
void* ecs_vec_last(
    const ecs_vec_t *vec,
    ecs_size_t size);

































typedef struct ecs_sparse_page_t {
    int32_t *sparse;            
    void *data;                 

} ecs_sparse_page_t;


typedef struct ecs_sparse_t {
    ecs_vec_t dense;            



    ecs_vec_t pages;            
    ecs_size_t size;            
    int32_t count;              
    uint64_t max_id;            
    struct ecs_allocator_t *allocator;       
    struct ecs_block_allocator_t *page_allocator; 
} ecs_sparse_t;








__declspec(dllimport)
void flecs_sparse_init(
    ecs_sparse_t *result,
    struct ecs_allocator_t *allocator,
    struct ecs_block_allocator_t *page_allocator,
    ecs_size_t size);















__declspec(dllimport)
void flecs_sparse_fini(
    ecs_sparse_t *sparse);





__declspec(dllimport)
void flecs_sparse_clear(
    ecs_sparse_t *sparse);







__declspec(dllimport)
void* flecs_sparse_add(
    ecs_sparse_t *sparse,
    ecs_size_t elem_size);















__declspec(dllimport)
uint64_t flecs_sparse_last_id(
    const ecs_sparse_t *sparse);






__declspec(dllimport)
uint64_t flecs_sparse_new_id(
    ecs_sparse_t *sparse);








__declspec(dllimport)
_Bool flecs_sparse_remove(
    ecs_sparse_t *sparse,
    ecs_size_t size,
    uint64_t id);

















_Bool flecs_sparse_remove_w_gen(
    ecs_sparse_t *sparse,
    ecs_size_t size,
    uint64_t id);
















__declspec(dllimport)
_Bool flecs_sparse_is_alive(
    const ecs_sparse_t *sparse,
    uint64_t id);









__declspec(dllimport)
void* flecs_sparse_get_dense(
    const ecs_sparse_t *sparse,
    ecs_size_t elem_size,
    int32_t index);
















__declspec(dllimport)
int32_t flecs_sparse_count(
    const ecs_sparse_t *sparse);







__declspec(dllimport)
_Bool flecs_sparse_has(
    const ecs_sparse_t *sparse,
    uint64_t id);








__declspec(dllimport)
 void* flecs_sparse_get(
    const ecs_sparse_t *sparse,
    ecs_size_t elem_size,
    uint64_t id);




__declspec(dllimport)
 void* flecs_sparse_get_w_check(
    const ecs_sparse_t *sparse,
    ecs_size_t elem_size,
    uint64_t id,
    _Bool checked);



















__declspec(dllimport)
void* flecs_sparse_ensure(
    ecs_sparse_t *sparse,
    ecs_size_t elem_size,
    uint64_t id,
    _Bool *is_new);



















__declspec(dllimport)
void* flecs_sparse_ensure_fast(
    ecs_sparse_t *sparse,
    ecs_size_t elem_size,
    uint64_t id);
















__declspec(dllimport)
const uint64_t* flecs_sparse_ids(
    const ecs_sparse_t *sparse);





__declspec(dllimport)
void flecs_sparse_shrink(
    ecs_sparse_t *sparse);











typedef struct ecs_map_t ecs_map_t;


typedef struct ecs_block_allocator_block_t {
    void *memory; 
    struct ecs_block_allocator_block_t *next; 
} ecs_block_allocator_block_t;


typedef struct ecs_block_allocator_chunk_header_t {
    struct ecs_block_allocator_chunk_header_t *next; 
} ecs_block_allocator_chunk_header_t;


typedef struct ecs_block_allocator_t {
    int32_t data_size; 

    int32_t chunk_size; 
    int32_t chunks_per_block; 
    int32_t block_size; 
    ecs_block_allocator_chunk_header_t *head; 
    ecs_block_allocator_block_t *block_head; 





} ecs_block_allocator_t;






__declspec(dllimport)
void flecs_ballocator_init(
    ecs_block_allocator_t *ba,
    ecs_size_t size);













__declspec(dllimport)
void flecs_ballocator_fini(
    ecs_block_allocator_t *ba);






__declspec(dllimport)
void* flecs_balloc(
    ecs_block_allocator_t *allocator);







__declspec(dllimport)
void* flecs_balloc_w_dbg_info(
    ecs_block_allocator_t *allocator,
    const char *type_name);






__declspec(dllimport)
void* flecs_bcalloc(
    ecs_block_allocator_t *allocator);







__declspec(dllimport)
void* flecs_bcalloc_w_dbg_info(
    ecs_block_allocator_t *allocator,
    const char *type_name);






__declspec(dllimport)
void flecs_bfree(
    ecs_block_allocator_t *allocator,
    void *memory);







__declspec(dllimport)
void flecs_bfree_w_dbg_info(
    ecs_block_allocator_t *allocator,
    void *memory,
    const char *type_name);








__declspec(dllimport)
void* flecs_brealloc(
    ecs_block_allocator_t *dst,
    ecs_block_allocator_t *src,
    void *memory);









__declspec(dllimport)
void* flecs_brealloc_w_dbg_info(
    ecs_block_allocator_t *dst,
    ecs_block_allocator_t *src,
    void *memory,
    const char *type_name);







typedef struct ecs_stack_page_t {
    void *data; 
    struct ecs_stack_page_t *next; 
    int16_t sp; 
    uint32_t id; 
} ecs_stack_page_t;


typedef struct ecs_stack_cursor_t {
    struct ecs_stack_cursor_t *prev; 
    struct ecs_stack_page_t *page; 
    int16_t sp; 
    _Bool is_free; 

    struct ecs_stack_t *owner; 

} ecs_stack_cursor_t;


typedef struct ecs_stack_t {
    ecs_stack_page_t *first; 
    ecs_stack_page_t *tail_page; 
    ecs_stack_cursor_t *tail_cursor; 

    int32_t cursor_count; 

} ecs_stack_t;











__declspec(dllimport)
void flecs_stack_init(
    ecs_stack_t *stack);





__declspec(dllimport)
void flecs_stack_fini(
    ecs_stack_t *stack);








__declspec(dllimport)
void* flecs_stack_alloc(
    ecs_stack_t *stack,
    ecs_size_t size,
    ecs_size_t align);
















__declspec(dllimport)
void* flecs_stack_calloc(
    ecs_stack_t *stack,
    ecs_size_t size,
    ecs_size_t align);














__declspec(dllimport)
void flecs_stack_free(
    void *ptr,
    ecs_size_t size);













void flecs_stack_reset(
    ecs_stack_t *stack);






__declspec(dllimport)
ecs_stack_cursor_t* flecs_stack_get_cursor(
    ecs_stack_t *stack);






__declspec(dllimport)
void flecs_stack_restore_cursor(
    ecs_stack_t *stack,
    ecs_stack_cursor_t *cursor);











typedef uint64_t ecs_map_data_t;


typedef ecs_map_data_t ecs_map_key_t;


typedef ecs_map_data_t ecs_map_val_t;


typedef struct ecs_bucket_entry_t {
    ecs_map_key_t key;                
    ecs_map_val_t value;              
    struct ecs_bucket_entry_t *next;  
} ecs_bucket_entry_t;


typedef struct ecs_bucket_t {
    ecs_bucket_entry_t *first;        
} ecs_bucket_t;


struct ecs_map_t {
    ecs_bucket_t *buckets;            
    int32_t bucket_count;             
    unsigned count : 26;              
    unsigned bucket_shift : 6;        
    struct ecs_allocator_t *allocator; 

    int32_t change_count;             
    ecs_map_key_t last_iterated;      

};


typedef struct ecs_map_iter_t {
    const ecs_map_t *map;             
    ecs_bucket_t *bucket;             
    ecs_bucket_entry_t *entry;        
    ecs_map_data_t *res;              

    int32_t change_count;             

} ecs_map_iter_t;














__declspec(dllimport)
void ecs_map_init(
    ecs_map_t *map,
    struct ecs_allocator_t *allocator);






__declspec(dllimport)
void ecs_map_init_if(
    ecs_map_t *map,
    struct ecs_allocator_t *allocator);





__declspec(dllimport)
void ecs_map_reclaim(
    ecs_map_t *map);





__declspec(dllimport)
void ecs_map_fini(
    ecs_map_t *map);







__declspec(dllimport)
ecs_map_val_t* ecs_map_get(
    const ecs_map_t *map,
    ecs_map_key_t key);







__declspec(dllimport)
void* ecs_map_get_deref_(
    const ecs_map_t *map,
    ecs_map_key_t key);







__declspec(dllimport)
ecs_map_val_t* ecs_map_ensure(
    ecs_map_t *map,
    ecs_map_key_t key);








__declspec(dllimport)
void* ecs_map_ensure_alloc(
    ecs_map_t *map,
    ecs_size_t elem_size,
    ecs_map_key_t key);







__declspec(dllimport)
void ecs_map_insert(
    ecs_map_t *map,
    ecs_map_key_t key,
    ecs_map_val_t value);








__declspec(dllimport)
void* ecs_map_insert_alloc(
    ecs_map_t *map,
    ecs_size_t elem_size,
    ecs_map_key_t key);







__declspec(dllimport)
ecs_map_val_t ecs_map_remove(
    ecs_map_t *map,
    ecs_map_key_t key);






__declspec(dllimport)
void ecs_map_remove_free(
    ecs_map_t *map,
    ecs_map_key_t key);





__declspec(dllimport)
void ecs_map_clear(
    ecs_map_t *map);












__declspec(dllimport)
ecs_map_iter_t ecs_map_iter(
    const ecs_map_t *map);






__declspec(dllimport)
_Bool ecs_map_iter_valid(
    ecs_map_iter_t *iter);






__declspec(dllimport)
_Bool ecs_map_next(
    ecs_map_iter_t *iter);






__declspec(dllimport)
void ecs_map_copy(
    ecs_map_t *dst,
    const ecs_map_t *src);














































__declspec(dllimport) extern int64_t ecs_block_allocator_alloc_count; 
__declspec(dllimport) extern int64_t ecs_block_allocator_free_count; 
__declspec(dllimport) extern int64_t ecs_stack_allocator_alloc_count; 
__declspec(dllimport) extern int64_t ecs_stack_allocator_free_count; 


struct ecs_allocator_t {

    ecs_block_allocator_t chunks; 
    struct ecs_sparse_t sizes; 



};





__declspec(dllimport)
void flecs_allocator_init(
    ecs_allocator_t *a);





__declspec(dllimport)
void flecs_allocator_fini(
    ecs_allocator_t *a);







__declspec(dllimport)
ecs_block_allocator_t* flecs_allocator_get(
    ecs_allocator_t *a,
    ecs_size_t size);







__declspec(dllimport)
char* flecs_strdup(
    ecs_allocator_t *a,
    const char* str);






__declspec(dllimport)
void flecs_strfree(
    ecs_allocator_t *a,
    char* str);








__declspec(dllimport)
void* flecs_dup(
    ecs_allocator_t *a,
    ecs_size_t size,
    const void *src);











































































































































































typedef struct ecs_strbuf_list_elem {
    int32_t count;            
    const char *separator;    
} ecs_strbuf_list_elem;


typedef struct ecs_strbuf_t {
    char *content;            
    ecs_size_t length;        
    ecs_size_t size;          

    ecs_strbuf_list_elem list_stack[(32)]; 
    int32_t list_sp;          

    char small_string[(512)]; 
} ecs_strbuf_t;






__declspec(dllimport)
void ecs_strbuf_append(
    ecs_strbuf_t *buffer,
    const char *fmt,
    ...);







__declspec(dllimport)
void ecs_strbuf_vappend(
    ecs_strbuf_t *buffer,
    const char *fmt,
    va_list args);






__declspec(dllimport)
void ecs_strbuf_appendstr(
    ecs_strbuf_t *buffer,
    const char *str);






__declspec(dllimport)
void ecs_strbuf_appendch(
    ecs_strbuf_t *buffer,
    char ch);






__declspec(dllimport)
void ecs_strbuf_appendint(
    ecs_strbuf_t *buffer,
    int64_t v);







__declspec(dllimport)
void ecs_strbuf_appendflt(
    ecs_strbuf_t *buffer,
    double v,
    char nan_delim);






__declspec(dllimport)
void ecs_strbuf_appendbool(
    ecs_strbuf_t *buffer,
    _Bool v);






__declspec(dllimport)
void ecs_strbuf_mergebuff(
    ecs_strbuf_t *dst_buffer,
    ecs_strbuf_t *src_buffer);







__declspec(dllimport)
void ecs_strbuf_appendstrn(
    ecs_strbuf_t *buffer,
    const char *str,
    int32_t n);






__declspec(dllimport)
char* ecs_strbuf_get(
    ecs_strbuf_t *buffer);






__declspec(dllimport)
char* ecs_strbuf_get_small(
    ecs_strbuf_t *buffer);





__declspec(dllimport)
void ecs_strbuf_reset(
    ecs_strbuf_t *buffer);







__declspec(dllimport)
void ecs_strbuf_list_push(
    ecs_strbuf_t *buffer,
    const char *list_open,
    const char *separator);






__declspec(dllimport)
void ecs_strbuf_list_pop(
    ecs_strbuf_t *buffer,
    const char *list_close);





__declspec(dllimport)
void ecs_strbuf_list_next(
    ecs_strbuf_t *buffer);






__declspec(dllimport)
void ecs_strbuf_list_appendch(
    ecs_strbuf_t *buffer,
    char ch);






__declspec(dllimport)
void ecs_strbuf_list_append(
    ecs_strbuf_t *buffer,
    const char *fmt,
    ...);






__declspec(dllimport)
void ecs_strbuf_list_appendstr(
    ecs_strbuf_t *buffer,
    const char *str);







__declspec(dllimport)
void ecs_strbuf_list_appendstrn(
    ecs_strbuf_t *buffer,
    const char *str,
    int32_t n);


__declspec(dllimport)
int32_t ecs_strbuf_written(
    const ecs_strbuf_t *buffer);



































#pragma once






#pragma warning(push)
#pragma warning(disable: 4324  4514 4574 4710 4793 4820 4995 4996 28719 28726 28727 )










    














typedef struct _heapinfo
{
    int* _pentry;
    size_t _size;
    int _useflag;
} _HEAPINFO;






   
void* __cdecl _alloca(  size_t _Size);





     intptr_t __cdecl _get_heap_handle(void);

     
     int __cdecl _heapmin(void);

    
         int __cdecl _heapwalk(  _HEAPINFO* _EntryInfo);
    

    
           int __cdecl _heapchk(void);
    

     int __cdecl _resetstkoflw(void);

    
    
    

    


        
    

    typedef char __static_assert_t[(sizeof(unsigned int) <= 8) != 0];


    #pragma warning(push)
    #pragma warning(disable: 6540) 
                                   

    __inline void* _MarkAllocaS(   void* _Ptr, unsigned int _Marker)
    {
        if (_Ptr)
        {
            *((unsigned int*)_Ptr) = _Marker;
            _Ptr = (char*)_Ptr + 8;
        }
        return _Ptr;
    }

    __inline size_t _MallocaComputeSize(size_t _Size)
    {
        size_t _MarkedSize = _Size + 8;
        return _MarkedSize > _Size ? _MarkedSize : 0;
    }

    #pragma warning(pop)



















    
    















    

    #pragma warning(push)
    #pragma warning(disable: 6014) 
    __inline void __cdecl _freea(    void* _Memory)
    {
        unsigned int _Marker;
        if (_Memory)
        {
            _Memory = (char*)_Memory - 8;
            _Marker = *(unsigned int*)_Memory;
            if (_Marker == 0xDDDD)
            {
                free(_Memory);
            }
            





        }
    }
    #pragma warning(pop)






    






#pragma warning(pop) 
















#pragma once














#pragma once










#pragma once



#pragma warning(push)
#pragma warning(disable: 4324  4514 4574 4710 4793 4820 4995 4996 28719 28726 28727 )












    



    
        
    



















    















    
















    
    
       
    
    __declspec(noinline) __inline unsigned __int64* __cdecl __local_stdio_printf_options(void)
    {
        static unsigned __int64 _OptionsStorage;
        return &_OptionsStorage;
    }

    
    
       
    
    __declspec(noinline) __inline unsigned __int64* __cdecl __local_stdio_scanf_options(void)
    {
        static unsigned __int64 _OptionsStorage;
        return &_OptionsStorage;
    }



























#pragma warning(pop) 


#pragma warning(push)
#pragma warning(disable: 4324  4514 4574 4710 4793 4820 4995 4996 28719 28726 28727 )










    
    typedef struct _iobuf
    {
        void* _Placeholder;
    } FILE;


 FILE* __cdecl __acrt_iob_func(unsigned _Ix);










    
    
    
    
    
    
     wint_t __cdecl fgetwc(
          FILE* _Stream
        );

    
     wint_t __cdecl _fgetwchar(void);

    
     wint_t __cdecl fputwc(
             wchar_t _Character,
          FILE*   _Stream);

    
     wint_t __cdecl _fputwchar(
          wchar_t _Character
        );

     
     wint_t __cdecl getwc(
          FILE* _Stream
        );

     
     wint_t __cdecl getwchar(void);


    
     
     wchar_t* __cdecl fgetws(
          wchar_t* _Buffer,
                                  int      _BufferCount,
                               FILE*    _Stream
        );

    
     int __cdecl fputws(
           wchar_t const* _Buffer,
          FILE*          _Stream
        );

    
     
     wchar_t* __cdecl _getws_s(
          wchar_t* _Buffer,
                                  size_t   _BufferCount
        );

    

    
     wint_t __cdecl putwc(
             wchar_t _Character,
          FILE*   _Stream
        );

    
     wint_t __cdecl putwchar(
          wchar_t _Character
        );

    
     int __cdecl _putws(
          wchar_t const* _Buffer
        );

    
     wint_t __cdecl ungetwc(
             wint_t _Character,
          FILE*  _Stream
        );

     
     FILE * __cdecl _wfdopen(
            int            _FileHandle,
          wchar_t const* _Mode
        );

      
     FILE* __cdecl _wfopen(
          wchar_t const* _FileName,
          wchar_t const* _Mode
        );

    
     errno_t __cdecl _wfopen_s(
          FILE**         _Stream,
                             wchar_t const* _FileName,
                             wchar_t const* _Mode
        );

     
    
     FILE* __cdecl _wfreopen(
           wchar_t const* _FileName,
           wchar_t const* _Mode,
          FILE*          _OldStream
        );

    
     errno_t __cdecl _wfreopen_s(
          FILE**         _Stream,
                             wchar_t const* _FileName,
                             wchar_t const* _Mode,
                            FILE*          _OldStream
        );

     
     FILE* __cdecl _wfsopen(
          wchar_t const* _FileName,
          wchar_t const* _Mode,
            int            _ShFlag
        );

     void __cdecl _wperror(
          wchar_t const* _ErrorMessage
        );

    

         
         FILE* __cdecl _wpopen(
              wchar_t const* _Command,
              wchar_t const* _Mode
            );

    

     int __cdecl _wremove(
          wchar_t const* _FileName
        );

    
    

     
      wchar_t* __cdecl _wtempnam(
          wchar_t const* _Directory,
          wchar_t const* _FilePrefix
        );

    

     
    
     errno_t __cdecl _wtmpnam_s(
          wchar_t* _Buffer,
                                  size_t   _BufferCount
        );

    

    



    
    
    
    
    
    
     wint_t __cdecl _fgetwc_nolock(
          FILE* _Stream
        );

    
     wint_t __cdecl _fputwc_nolock(
             wchar_t _Character,
          FILE*   _Stream
        );

    
     wint_t __cdecl _getwc_nolock(
          FILE* _Stream
        );

    
     wint_t __cdecl _putwc_nolock(
             wchar_t _Character,
          FILE*   _Stream
        );

    
     wint_t __cdecl _ungetwc_nolock(
             wint_t _Character,
          FILE*  _Stream
        );

    







    
    





    
    
    
    
    
    
     int __cdecl __stdio_common_vfwprintf(
                                             unsigned __int64 _Options,
                                          FILE*            _Stream,
            wchar_t const*   _Format,
                                         _locale_t        _Locale,
                                                va_list          _ArgList
        );

    
     int __cdecl __stdio_common_vfwprintf_s(
                                             unsigned __int64 _Options,
                                          FILE*            _Stream,
            wchar_t const*   _Format,
                                         _locale_t        _Locale,
                                                va_list          _ArgList
        );

    
     int __cdecl __stdio_common_vfwprintf_p(
                                             unsigned __int64 _Options,
                                          FILE*            _Stream,
            wchar_t const*   _Format,
                                         _locale_t        _Locale,
                                                va_list          _ArgList
        );

    
    __inline int __cdecl _vfwprintf_l(
                                          FILE*          const _Stream,
            wchar_t const* const _Format,
                                         _locale_t      const _Locale,
                                                va_list              _ArgList
        )
    


    {
        return __stdio_common_vfwprintf((*__local_stdio_printf_options()), _Stream, _Format, _Locale, _ArgList);
    }
    

    
    __inline int __cdecl vfwprintf(
                                FILE*          const _Stream,
            wchar_t const* const _Format,
                                      va_list              _ArgList
        )
    


    {
        return _vfwprintf_l(_Stream, _Format, ((void *)0), _ArgList);
    }
    

    
    __inline int __cdecl _vfwprintf_s_l(
                                          FILE*          const _Stream,
            wchar_t const* const _Format,
                                         _locale_t      const _Locale,
                                                va_list              _ArgList
        )
    


    {
        return __stdio_common_vfwprintf_s((*__local_stdio_printf_options()), _Stream, _Format, _Locale, _ArgList);
    }
    

    

        
        __inline int __cdecl vfwprintf_s(
                                    FILE*          const _Stream,
                wchar_t const* const _Format,
                                          va_list              _ArgList
            )
    


        {
            return _vfwprintf_s_l(_Stream, _Format, ((void *)0), _ArgList);
        }
    

    

    
    __inline int __cdecl _vfwprintf_p_l(
                                          FILE*          const _Stream,
            wchar_t const* const _Format,
                                         _locale_t      const _Locale,
                                                va_list              _ArgList
        )
    


    {
        return __stdio_common_vfwprintf_p((*__local_stdio_printf_options()), _Stream, _Format, _Locale, _ArgList);
    }
    

    
    __inline int __cdecl _vfwprintf_p(
                                FILE*          const _Stream,
            wchar_t const* const _Format,
                                      va_list              _ArgList
        )
    


    {
        return _vfwprintf_p_l(_Stream, _Format, ((void *)0), _ArgList);
    }
    

    
    __inline int __cdecl _vwprintf_l(
            wchar_t const* const _Format,
                                         _locale_t      const _Locale,
                                                va_list              _ArgList
        )
    


    {
        return _vfwprintf_l((__acrt_iob_func(1)), _Format, _Locale, _ArgList);
    }
    

    
    __inline int __cdecl vwprintf(
            wchar_t const* const _Format,
                                      va_list              _ArgList
        )
    


    {
        return _vfwprintf_l((__acrt_iob_func(1)), _Format, ((void *)0), _ArgList);
    }
    

    
    __inline int __cdecl _vwprintf_s_l(
            wchar_t const* const _Format,
                                         _locale_t      const _Locale,
                                                va_list              _ArgList
        )
    


    {
        return _vfwprintf_s_l((__acrt_iob_func(1)), _Format, _Locale, _ArgList);
    }
    

    

        
        __inline int __cdecl vwprintf_s(
                wchar_t const* const _Format,
                                          va_list              _ArgList
            )
    


        {
            return _vfwprintf_s_l((__acrt_iob_func(1)), _Format, ((void *)0), _ArgList);
        }
    

    

    
    __inline int __cdecl _vwprintf_p_l(
            wchar_t const* const _Format,
                                         _locale_t      const _Locale,
                                                va_list              _ArgList
        )
    


    {
        return _vfwprintf_p_l((__acrt_iob_func(1)), _Format, _Locale, _ArgList);
    }
    

    
    __inline int __cdecl _vwprintf_p(
            wchar_t const* const _Format,
                                      va_list              _ArgList
        )
    


    {
        return _vfwprintf_p_l((__acrt_iob_func(1)), _Format, ((void *)0), _ArgList);
    }
    

    
    __inline int __cdecl _fwprintf_l(
                                          FILE*          const _Stream,
            wchar_t const* const _Format,
                                         _locale_t      const _Locale,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Locale)) + ((sizeof(_Locale) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vfwprintf_l(_Stream, _Format, _Locale, _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

    
    __inline int __cdecl fwprintf(
                                FILE*          const _Stream,
            wchar_t const* const _Format,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Format)) + ((sizeof(_Format) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vfwprintf_l(_Stream, _Format, ((void *)0), _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

    
    __inline int __cdecl _fwprintf_s_l(
                                          FILE*          const _Stream,
            wchar_t const* const _Format,
                                         _locale_t      const _Locale,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Locale)) + ((sizeof(_Locale) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vfwprintf_s_l(_Stream, _Format, _Locale, _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

    

        
        __inline int __cdecl fwprintf_s(
                                    FILE*          const _Stream,
                wchar_t const* const _Format,
            ...)
    


        {
            int _Result;
            va_list _ArgList;
            ((void)(_ArgList = (va_list)(&(_Format)) + ((sizeof(_Format) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
            _Result = _vfwprintf_s_l(_Stream, _Format, ((void *)0), _ArgList);
            ((void)(_ArgList = (va_list)0));
            return _Result;
        }
    

    

    
    __inline int __cdecl _fwprintf_p_l(
                                          FILE*          const _Stream,
            wchar_t const* const _Format,
                                         _locale_t      const _Locale,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Locale)) + ((sizeof(_Locale) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vfwprintf_p_l(_Stream, _Format, _Locale, _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

    
    __inline int __cdecl _fwprintf_p(
                                FILE*          const _Stream,
            wchar_t const* const _Format,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Format)) + ((sizeof(_Format) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vfwprintf_p_l(_Stream, _Format, ((void *)0), _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

    
    __inline int __cdecl _wprintf_l(
            wchar_t const* const _Format,
                                         _locale_t      const _Locale,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Locale)) + ((sizeof(_Locale) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vfwprintf_l((__acrt_iob_func(1)), _Format, _Locale, _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

    
    __inline int __cdecl wprintf(
            wchar_t const* const _Format,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Format)) + ((sizeof(_Format) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vfwprintf_l((__acrt_iob_func(1)), _Format, ((void *)0), _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

    
    __inline int __cdecl _wprintf_s_l(
            wchar_t const* const _Format,
                                         _locale_t      const _Locale,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Locale)) + ((sizeof(_Locale) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vfwprintf_s_l((__acrt_iob_func(1)), _Format, _Locale, _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

    

        
        __inline int __cdecl wprintf_s(
                wchar_t const* const _Format,
            ...)
    


        {
            int _Result;
            va_list _ArgList;
            ((void)(_ArgList = (va_list)(&(_Format)) + ((sizeof(_Format) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
            _Result = _vfwprintf_s_l((__acrt_iob_func(1)), _Format, ((void *)0), _ArgList);
            ((void)(_ArgList = (va_list)0));
            return _Result;
        }
    

    

    
    __inline int __cdecl _wprintf_p_l(
            wchar_t const* const _Format,
                                         _locale_t      const _Locale,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Locale)) + ((sizeof(_Locale) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vfwprintf_p_l((__acrt_iob_func(1)), _Format, _Locale, _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

    
    __inline int __cdecl _wprintf_p(
            wchar_t const* const _Format,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Format)) + ((sizeof(_Format) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vfwprintf_p_l((__acrt_iob_func(1)), _Format, ((void *)0), _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    


    
    
    
    
    
    
     int __cdecl __stdio_common_vfwscanf(
                                            unsigned __int64 _Options,
                                         FILE*            _Stream,
            wchar_t const*   _Format,
                                        _locale_t        _Locale,
                                               va_list          _ArgList
        );

    
    __inline int __cdecl _vfwscanf_l(
          FILE*                                const _Stream,
            wchar_t const* const _Format,
                               _locale_t      const _Locale,
                                      va_list              _ArgList
        )
    


    {
        return __stdio_common_vfwscanf(
            (*__local_stdio_scanf_options ()),
            _Stream, _Format, _Locale, _ArgList);
    }
    

    
    __inline int __cdecl vfwscanf(
          FILE*                                const _Stream,
            wchar_t const* const _Format,
                                      va_list              _ArgList
        )
    


    {
        return _vfwscanf_l(_Stream, _Format, ((void *)0), _ArgList);
    }
    

    
    __inline int __cdecl _vfwscanf_s_l(
                                FILE*          const _Stream,
            wchar_t const* const _Format,
                               _locale_t      const _Locale,
                                      va_list              _ArgList
        )
    


    {
        return __stdio_common_vfwscanf(
            (*__local_stdio_scanf_options ()) | (1ULL << 0),
            _Stream, _Format, _Locale, _ArgList);
    }
    

    

        
        __inline int __cdecl vfwscanf_s(
                                    FILE*          const _Stream,
                wchar_t const* const _Format,
                                          va_list              _ArgList
            )
    


        {
            return _vfwscanf_s_l(_Stream, _Format, ((void *)0), _ArgList);
        }
    

    

    __inline int __cdecl _vwscanf_l(
            wchar_t const* const _Format,
                               _locale_t      const _Locale,
                                      va_list              _ArgList
        )
    


    {
        return _vfwscanf_l((__acrt_iob_func(0)), _Format, _Locale, _ArgList);
    }
    

    
    __inline int __cdecl vwscanf(
            wchar_t const* const _Format,
                                      va_list              _ArgList
        )
    


    {
        return _vfwscanf_l((__acrt_iob_func(0)), _Format, ((void *)0), _ArgList);
    }
    

    
    __inline int __cdecl _vwscanf_s_l(
            wchar_t const* const _Format,
                               _locale_t      const _Locale,
                                      va_list              _ArgList
        )
    


    {
        return _vfwscanf_s_l((__acrt_iob_func(0)), _Format, _Locale, _ArgList);
    }
    

    

        
        __inline int __cdecl vwscanf_s(
                wchar_t const* const _Format,
                                          va_list              _ArgList
            )
    


        {
            return _vfwscanf_s_l((__acrt_iob_func(0)), _Format, ((void *)0), _ArgList);
        }
    

    

     
    __inline int __cdecl _fwscanf_l(
                                         FILE*          const _Stream,
            wchar_t const* const _Format,
                                        _locale_t      const _Locale,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Locale)) + ((sizeof(_Locale) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vfwscanf_l(_Stream, _Format, _Locale, _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

      
    __inline int __cdecl fwscanf(
                               FILE*          const _Stream,
            wchar_t const* const _Format,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Format)) + ((sizeof(_Format) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vfwscanf_l(_Stream, _Format, ((void *)0), _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

    
    __inline int __cdecl _fwscanf_s_l(
                                           FILE*          const _Stream,
            wchar_t const* const _Format,
                                          _locale_t      const _Locale,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Locale)) + ((sizeof(_Locale) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vfwscanf_s_l(_Stream, _Format, _Locale, _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

    

        
        __inline int __cdecl fwscanf_s(
                                     FILE*          const _Stream,
                wchar_t const* const _Format,
            ...)
    


        {
            int _Result;
            va_list _ArgList;
            ((void)(_ArgList = (va_list)(&(_Format)) + ((sizeof(_Format) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
            _Result = _vfwscanf_s_l(_Stream, _Format, ((void *)0), _ArgList);
            ((void)(_ArgList = (va_list)0));
            return _Result;
        }
    

    

     
    __inline int __cdecl _wscanf_l(
            wchar_t const* const _Format,
                                        _locale_t      const _Locale,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Locale)) + ((sizeof(_Locale) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vfwscanf_l((__acrt_iob_func(0)), _Format, _Locale, _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

      
    __inline int __cdecl wscanf(
            wchar_t const* const _Format,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Format)) + ((sizeof(_Format) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vfwscanf_l((__acrt_iob_func(0)), _Format, ((void *)0), _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

    
    __inline int __cdecl _wscanf_s_l(
            wchar_t const* const _Format,
                                          _locale_t      const _Locale,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Locale)) + ((sizeof(_Locale) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vfwscanf_s_l((__acrt_iob_func(0)), _Format, _Locale, _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

    

        
        __inline int __cdecl wscanf_s(
                wchar_t const* const _Format,
            ...)
    


        {
            int _Result;
            va_list _ArgList;
            ((void)(_ArgList = (va_list)(&(_Format)) + ((sizeof(_Format) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
            _Result = _vfwscanf_s_l((__acrt_iob_func(0)), _Format, ((void *)0), _ArgList);
            ((void)(_ArgList = (va_list)0));
            return _Result;
        }
    

    



    
    
    
    
    
    
        



    



     
    
     int __cdecl __stdio_common_vswprintf(
                                             unsigned __int64 _Options,
                 wchar_t*         _Buffer,
                                             size_t           _BufferCount,
            wchar_t const*   _Format,
                                         _locale_t        _Locale,
                                                va_list          _ArgList
        );

     
    
     int __cdecl __stdio_common_vswprintf_s(
                                             unsigned __int64 _Options,
                     wchar_t*         _Buffer,
                                             size_t           _BufferCount,
            wchar_t const*   _Format,
                                         _locale_t        _Locale,
                                                va_list          _ArgList
        );

     
    
     int __cdecl __stdio_common_vsnwprintf_s(
                                             unsigned __int64 _Options,
                 wchar_t*         _Buffer,
                                             size_t           _BufferCount,
                                             size_t           _MaxCount,
            wchar_t const*   _Format,
                                         _locale_t        _Locale,
                                                va_list          _ArgList
        );

     
    
     int __cdecl __stdio_common_vswprintf_p(
                                             unsigned __int64 _Options,
                     wchar_t*         _Buffer,
                                             size_t           _BufferCount,
            wchar_t const*   _Format,
                                         _locale_t        _Locale,
                                                va_list          _ArgList
        );

     
     
    __inline int __cdecl _vsnwprintf_l(
            wchar_t*       const _Buffer,
                                                  size_t         const _BufferCount,
                 wchar_t const* const _Format,
                                              _locale_t      const _Locale,
                                                     va_list              _ArgList
        )
    


    {
        int const _Result = __stdio_common_vswprintf(
            (*__local_stdio_printf_options()) | (1ULL << 0),
            _Buffer, _BufferCount, _Format, _Locale, _ArgList);

        return _Result < 0 ? -1 : _Result;
    }
    

     
    
    __inline int __cdecl _vsnwprintf_s_l(
           wchar_t*       const _Buffer,
                                                       size_t         const _BufferCount,
                                                       size_t         const _MaxCount,
                      wchar_t const* const _Format,
                                                   _locale_t      const _Locale,
                                                          va_list              _ArgList
        )
    


    {
        int const _Result = __stdio_common_vsnwprintf_s(
            (*__local_stdio_printf_options()),
            _Buffer, _BufferCount, _MaxCount, _Format, _Locale, _ArgList);

        return _Result < 0 ? -1 : _Result;
    }
    

     
    
    __inline int __cdecl _vsnwprintf_s(
           wchar_t*       const _Buffer,
                                                       size_t         const _BufferCount,
                                                       size_t         const _MaxCount,
                                wchar_t const* const _Format,
                                                          va_list              _ArgList
        )
    


    {
        return _vsnwprintf_s_l(_Buffer, _BufferCount, _MaxCount, _Format, ((void *)0), _ArgList);
    }
    

    

     
     
    __inline int __cdecl _vsnwprintf(
            wchar_t*       _Buffer,
                                                  size_t         _BufferCount,
                           wchar_t const* _Format,
                                                     va_list        _ArgList
        )
    


    {
        return _vsnwprintf_l(_Buffer, _BufferCount, _Format, ((void *)0), _ArgList);
    }
    

    

     
    
    __inline int __cdecl _vswprintf_c_l(
           wchar_t*       const _Buffer,
                                                       size_t         const _BufferCount,
                      wchar_t const* const _Format,
                                                   _locale_t      const _Locale,
                                                          va_list              _ArgList
        )
    


    {
        int const _Result = __stdio_common_vswprintf(
            (*__local_stdio_printf_options()),
            _Buffer, _BufferCount, _Format, _Locale, _ArgList);

        return _Result < 0 ? -1 : _Result;
    }
    

     
    
    __inline int __cdecl _vswprintf_c(
           wchar_t*       const _Buffer,
                                                       size_t         const _BufferCount,
                                wchar_t const* const _Format,
                                                          va_list              _ArgList
        )
    


    {
        return _vswprintf_c_l(_Buffer, _BufferCount, _Format, ((void *)0), _ArgList);
    }
    

     
    
    __inline int __cdecl _vswprintf_l(
           wchar_t*       const _Buffer,
                                                       size_t         const _BufferCount,
                      wchar_t const* const _Format,
                                                   _locale_t      const _Locale,
                                                          va_list              _ArgList
        )
    


    {
        return _vswprintf_c_l(_Buffer, _BufferCount, _Format, _Locale, _ArgList);
    }
    

     
    
    __inline int __cdecl __vswprintf_l(
                  wchar_t*       const _Buffer,
            wchar_t const* const _Format,
                                         _locale_t      const _Locale,
                                                va_list              _ArgList
        )
    


    {
        return _vswprintf_l(_Buffer, (size_t)-1, _Format, _Locale, _ArgList);
    }
    

     
    
    __inline int __cdecl _vswprintf(
           wchar_t*       const _Buffer,
               wchar_t const* const _Format,
                                         va_list              _ArgList
        )
    


    {
        return _vswprintf_l(_Buffer, (size_t)-1, _Format, ((void *)0), _ArgList);
    }
    

     
    
    __inline int __cdecl vswprintf(
           wchar_t*       const _Buffer,
                                                       size_t         const _BufferCount,
                      wchar_t const* const _Format,
                                                          va_list              _ArgList
        )
    


    {
        return _vswprintf_c_l(_Buffer, _BufferCount, _Format, ((void *)0), _ArgList);
    }
    

     
    
    __inline int __cdecl _vswprintf_s_l(
           wchar_t*       const _Buffer,
                                                   size_t         const _BufferCount,
                  wchar_t const* const _Format,
                                               _locale_t      const _Locale,
                                                      va_list              _ArgList
        )
    


    {
        int const _Result = __stdio_common_vswprintf_s(
            (*__local_stdio_printf_options()),
            _Buffer, _BufferCount, _Format, _Locale, _ArgList);

        return _Result < 0 ? -1 : _Result;
    }
    

    

         
        __inline int __cdecl vswprintf_s(
               wchar_t*       const _Buffer,
                                                       size_t         const _BufferCount,
                                wchar_t const* const _Format,
                                                          va_list              _ArgList
            )
    


        {
            return _vswprintf_s_l(_Buffer, _BufferCount, _Format, ((void *)0), _ArgList);
        }
    

    

    

     
    
    __inline int __cdecl _vswprintf_p_l(
           wchar_t*       const _Buffer,
                                                   size_t         const _BufferCount,
                  wchar_t const* const _Format,
                                               _locale_t      const _Locale,
                                                      va_list              _ArgList
        )
    


    {
        int const _Result = __stdio_common_vswprintf_p(
            (*__local_stdio_printf_options()),
            _Buffer, _BufferCount, _Format, _Locale, _ArgList);

        return _Result < 0 ? -1 : _Result;
    }
    

     
    
    __inline int __cdecl _vswprintf_p(
           wchar_t*       const _Buffer,
                                                   size_t         const _BufferCount,
                            wchar_t const* const _Format,
                                                      va_list              _ArgList
        )
    


    {
        return _vswprintf_p_l(_Buffer, _BufferCount, _Format, ((void *)0), _ArgList);
    }
    

     
     
    __inline int __cdecl _vscwprintf_l(
            wchar_t const* const _Format,
                                         _locale_t      const _Locale,
                                                va_list              _ArgList
        )
    


    {
        int const _Result = __stdio_common_vswprintf(
            (*__local_stdio_printf_options()) | (1ULL << 1),
            ((void *)0), 0, _Format, _Locale, _ArgList);

        return _Result < 0 ? -1 : _Result;
    }
    

     
     
    __inline int __cdecl _vscwprintf(
            wchar_t const* const _Format,
                                      va_list              _ArgList
        )
    


    {
        return _vscwprintf_l(_Format, ((void *)0), _ArgList);
    }
    

     
     
    __inline int __cdecl _vscwprintf_p_l(
            wchar_t const* const _Format,
                                         _locale_t      const _Locale,
                                                va_list              _ArgList
        )
    


    {
        int const _Result = __stdio_common_vswprintf_p(
            (*__local_stdio_printf_options()) | (1ULL << 1),
            ((void *)0), 0, _Format, _Locale, _ArgList);

        return _Result < 0 ? -1 : _Result;
    }
    

     
     
    __inline int __cdecl _vscwprintf_p(
            wchar_t const* const _Format,
                                      va_list              _ArgList
        )
    


    {
        return _vscwprintf_p_l(_Format, ((void *)0), _ArgList);
    }
    

     
    
    __inline int __cdecl __swprintf_l(
                  wchar_t*       const _Buffer,
            wchar_t const* const _Format,
                                         _locale_t      const _Locale,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Locale)) + ((sizeof(_Locale) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = __vswprintf_l(_Buffer, _Format, _Locale, _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

     
    
    __inline int __cdecl _swprintf_l(
           wchar_t*       const _Buffer,
                                                       size_t         const _BufferCount,
                      wchar_t const* const _Format,
                                                   _locale_t      const _Locale,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Locale)) + ((sizeof(_Locale) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vswprintf_c_l(_Buffer, _BufferCount, _Format, _Locale, _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

     
    
    __inline int __cdecl _swprintf(
           wchar_t*       const _Buffer,
               wchar_t const* const _Format,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Format)) + ((sizeof(_Format) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = __vswprintf_l(_Buffer, _Format, ((void *)0), _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

     
    
    __inline int __cdecl swprintf(
           wchar_t*       const _Buffer,
                                                       size_t         const _BufferCount,
                                wchar_t const* const _Format,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Format)) + ((sizeof(_Format) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vswprintf_c_l(_Buffer, _BufferCount, _Format, ((void *)0), _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

    

    

     
    
    __inline int __cdecl _swprintf_s_l(
           wchar_t*       const _Buffer,
                                                   size_t         const _BufferCount,
                  wchar_t const* const _Format,
                                               _locale_t      const _Locale,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Locale)) + ((sizeof(_Locale) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vswprintf_s_l(_Buffer, _BufferCount, _Format, _Locale, _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

    

         
        __inline int __cdecl swprintf_s(
               wchar_t*       const _Buffer,
                                                       size_t         const _BufferCount,
                                wchar_t const* const _Format,
            ...)
    


        {
            int _Result;
            va_list _ArgList;
            ((void)(_ArgList = (va_list)(&(_Format)) + ((sizeof(_Format) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
            _Result = _vswprintf_s_l(_Buffer, _BufferCount, _Format, ((void *)0), _ArgList);
            ((void)(_ArgList = (va_list)0));
            return _Result;
        }
    

    

    

     
    
    __inline int __cdecl _swprintf_p_l(
           wchar_t*       const _Buffer,
                                                   size_t         const _BufferCount,
                  wchar_t const* const _Format,
                                               _locale_t      const _Locale,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Locale)) + ((sizeof(_Locale) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vswprintf_p_l(_Buffer, _BufferCount, _Format, _Locale, _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

     
    
    __inline int __cdecl _swprintf_p(
           wchar_t*       const _Buffer,
                                                   size_t         const _BufferCount,
                            wchar_t const* const _Format,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Format)) + ((sizeof(_Format) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vswprintf_p_l(_Buffer, _BufferCount, _Format, ((void *)0), _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

     
    
    __inline int __cdecl _swprintf_c_l(
           wchar_t*       const _Buffer,
                                                       size_t         const _BufferCount,
                      wchar_t const* const _Format,
                                                   _locale_t      const _Locale,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Locale)) + ((sizeof(_Locale) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vswprintf_c_l(_Buffer, _BufferCount, _Format, _Locale, _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

     
    
    __inline int __cdecl _swprintf_c(
           wchar_t*       const _Buffer,
                                                       size_t         const _BufferCount,
                                wchar_t const* const _Format,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Format)) + ((sizeof(_Format) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vswprintf_c_l(_Buffer, _BufferCount, _Format, ((void *)0), _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

     
     
    __inline int __cdecl _snwprintf_l(
            wchar_t*       const _Buffer,
                                                  size_t         const _BufferCount,
                 wchar_t const* const _Format,
                                              _locale_t      const _Locale,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Locale)) + ((sizeof(_Locale) + sizeof(int) - 1) & ~(sizeof(int) - 1))));

        _Result = _vsnwprintf_l(_Buffer, _BufferCount, _Format, _Locale, _ArgList);

        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

     
    
    __inline int __cdecl _snwprintf(
            wchar_t*       _Buffer,
                                                  size_t         _BufferCount,
                           wchar_t const* _Format,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Format)) + ((sizeof(_Format) + sizeof(int) - 1) & ~(sizeof(int) - 1))));

        _Result = _vsnwprintf_l(_Buffer, _BufferCount, _Format, ((void *)0), _ArgList);

        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

     
    
    __inline int __cdecl _snwprintf_s_l(
           wchar_t*       const _Buffer,
                                                       size_t         const _BufferCount,
                                                       size_t         const _MaxCount,
                      wchar_t const* const _Format,
                                                   _locale_t      const _Locale,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Locale)) + ((sizeof(_Locale) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vsnwprintf_s_l(_Buffer, _BufferCount, _MaxCount, _Format, _Locale, _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

     
    
    __inline int __cdecl _snwprintf_s(
           wchar_t*       const _Buffer,
                                                       size_t         const _BufferCount,
                                                       size_t         const _MaxCount,
                                wchar_t const* const _Format,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Format)) + ((sizeof(_Format) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vsnwprintf_s_l(_Buffer, _BufferCount, _MaxCount, _Format, ((void *)0), _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

    

     
    __inline int __cdecl _scwprintf_l(
            wchar_t const* const _Format,
                                         _locale_t      const _Locale,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Locale)) + ((sizeof(_Locale) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vscwprintf_l(_Format, _Locale, _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

     
     
    __inline int __cdecl _scwprintf(
            wchar_t const* const _Format,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Format)) + ((sizeof(_Format) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vscwprintf_l(_Format, ((void *)0), _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

     
     
    __inline int __cdecl _scwprintf_p_l(
            wchar_t const* const _Format,
                                         _locale_t      const _Locale,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Locale)) + ((sizeof(_Locale) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vscwprintf_p_l(_Format, _Locale, _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

     
     
    __inline int __cdecl _scwprintf_p(
            wchar_t const* const _Format,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Format)) + ((sizeof(_Format) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vscwprintf_p_l(_Format, ((void *)0), _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    


    
        
        
        #pragma warning(push)
        #pragma warning(disable: 4141 6054)

        





















































        #pragma warning(pop)
    

    







    
    
    
    
    
     
     int __cdecl __stdio_common_vswscanf(
                                            unsigned __int64 _Options,
                  wchar_t const*   _Buffer,
                                            size_t           _BufferCount,
            wchar_t const*   _Format,
                                        _locale_t        _Locale,
                                               va_list          _ArgList
        );

     
    
    __inline int __cdecl _vswscanf_l(
                                 wchar_t const* const _Buffer,
            wchar_t const* const _Format,
                               _locale_t      const _Locale,
                                      va_list              _ArgList
        )
    


    {
        return __stdio_common_vswscanf(
            (*__local_stdio_scanf_options ()),
            _Buffer, (size_t)-1, _Format, _Locale, _ArgList);
    }
    

     
    
    __inline int __cdecl vswscanf(
                                 wchar_t const* _Buffer,
            wchar_t const* _Format,
                                      va_list        _ArgList
        )
    


    {
        return _vswscanf_l(_Buffer, _Format, ((void *)0), _ArgList);
    }
    

     
    
    __inline int __cdecl _vswscanf_s_l(
                                 wchar_t const* const _Buffer,
            wchar_t const* const _Format,
                               _locale_t      const _Locale,
                                      va_list              _ArgList
        )
    


    {
        return __stdio_common_vswscanf(
            (*__local_stdio_scanf_options ()) | (1ULL << 0),
            _Buffer, (size_t)-1, _Format, _Locale, _ArgList);
    }
    

    

         
        
        __inline int __cdecl vswscanf_s(
                                     wchar_t const* const _Buffer,
                wchar_t const* const _Format,
                                          va_list              _ArgList
            )
    


        {
            return _vswscanf_s_l(_Buffer, _Format, ((void *)0), _ArgList);
        }
    

    

    

     
     
    __inline int __cdecl _vsnwscanf_l(
                  wchar_t const* const _Buffer,
                                            size_t         const _BufferCount,
            wchar_t const* const _Format,
                                        _locale_t      const _Locale,
                                               va_list              _ArgList
        )
    


    {
        return __stdio_common_vswscanf(
            (*__local_stdio_scanf_options ()),
            _Buffer, _BufferCount, _Format, _Locale, _ArgList);
    }
    

     
    
    __inline int __cdecl _vsnwscanf_s_l(
                    wchar_t const* const _Buffer,
                                              size_t         const _BufferCount,
            wchar_t const* const _Format,
                                          _locale_t      const _Locale,
                                                 va_list              _ArgList
        )
    


    {
        return __stdio_common_vswscanf(
            (*__local_stdio_scanf_options ()) | (1ULL << 0),
            _Buffer, _BufferCount, _Format, _Locale, _ArgList);
    }
    

     
     
    __inline int __cdecl _swscanf_l(
                                          wchar_t const* const _Buffer,
            wchar_t const* const _Format,
                                        _locale_t            _Locale,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Locale)) + ((sizeof(_Locale) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vswscanf_l(_Buffer, _Format, _Locale, _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

     
      
    __inline int __cdecl swscanf(
                                wchar_t const* const _Buffer,
            wchar_t const* const _Format,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Format)) + ((sizeof(_Format) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vswscanf_l(_Buffer, _Format, ((void *)0), _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

     
    
    __inline int __cdecl _swscanf_s_l(
                                            wchar_t const* const _Buffer,
            wchar_t const* const _Format,
                                          _locale_t      const _Locale,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Locale)) + ((sizeof(_Locale) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vswscanf_s_l(_Buffer, _Format, _Locale, _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

    

         
        
        __inline int __cdecl swscanf_s(
                                      wchar_t const* const _Buffer,
                wchar_t const* const _Format,
            ...)
    


        {
            int _Result;
            va_list _ArgList;
            ((void)(_ArgList = (va_list)(&(_Format)) + ((sizeof(_Format) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
            _Result = _vswscanf_s_l(_Buffer, _Format, ((void *)0), _ArgList);
            ((void)(_ArgList = (va_list)0));
            return _Result;
        }
    

    

     
     
    __inline int __cdecl _snwscanf_l(
                  wchar_t const* const _Buffer,
                                            size_t         const _BufferCount,
            wchar_t const* const _Format,
                                        _locale_t      const _Locale,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Locale)) + ((sizeof(_Locale) + sizeof(int) - 1) & ~(sizeof(int) - 1))));

        _Result = _vsnwscanf_l(_Buffer, _BufferCount, _Format, _Locale, _ArgList);

        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

     
     
    __inline int __cdecl _snwscanf(
            wchar_t const* const _Buffer,
                                      size_t         const _BufferCount,
                wchar_t const* const _Format,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Format)) + ((sizeof(_Format) + sizeof(int) - 1) & ~(sizeof(int) - 1))));

        _Result = _vsnwscanf_l(_Buffer, _BufferCount, _Format, ((void *)0), _ArgList);

        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

     
    
    __inline int __cdecl _snwscanf_s_l(
                    wchar_t const* const _Buffer,
                                              size_t         const _BufferCount,
            wchar_t const* const _Format,
                                          _locale_t      const _Locale,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Locale)) + ((sizeof(_Locale) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vsnwscanf_s_l(_Buffer, _BufferCount, _Format, _Locale, _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

     
    
    __inline int __cdecl _snwscanf_s(
             wchar_t const* const _Buffer,
                                       size_t         const _BufferCount,
               wchar_t const* const _Format,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Format)) + ((sizeof(_Format) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vsnwscanf_s_l(_Buffer, _BufferCount, _Format, ((void *)0), _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

    






#pragma warning(pop) 


#pragma warning(push)
#pragma warning(disable: 4324  4514 4574 4710 4793 4820 4995 4996 28719 28726 28727 )


































    
















    
    



typedef __int64 fpos_t;





    
     errno_t __cdecl _get_stream_buffer_pointers(
               FILE*   _Stream,
          char*** _Base,
          char*** _Pointer,
          int**   _Count
        );


    
    
    
    
    
    

        
         errno_t __cdecl clearerr_s(
              FILE* _Stream
            );

        
         
         errno_t __cdecl fopen_s(
              FILE**      _Stream,
                                     char const* _FileName,
                                     char const* _Mode
            );

        
         
         size_t __cdecl fread_s(
                void*  _Buffer,
                                    size_t _BufferSize,
                                                                            size_t _ElementSize,
                                                                            size_t _ElementCount,
                                                                         FILE*  _Stream
            );

        
         errno_t __cdecl freopen_s(
              FILE**      _Stream,
                                 char const* _FileName,
                                 char const* _Mode,
                                FILE*       _OldStream
            );

         
         char* __cdecl gets_s(
              char*   _Buffer,
                               rsize_t _Size
            );

        
         errno_t __cdecl tmpfile_s(
                FILE** _Stream
            );

         
        
         errno_t __cdecl tmpnam_s(
              char*   _Buffer,
                               rsize_t _Size
            );

    

     void __cdecl clearerr(
          FILE* _Stream
        );

     
    
     int __cdecl fclose(
          FILE* _Stream
        );

    
     int __cdecl _fcloseall(void);

     
     FILE* __cdecl _fdopen(
            int         _FileHandle,
          char const* _Mode
        );

     
     int __cdecl feof(
          FILE* _Stream
        );

     
     int __cdecl ferror(
          FILE* _Stream
        );

    
     int __cdecl fflush(
          FILE* _Stream
        );

     
    
     int __cdecl fgetc(
          FILE* _Stream
        );

    
     int __cdecl _fgetchar(void);

     
    
     int __cdecl fgetpos(
          FILE*   _Stream,
            fpos_t* _Position
        );

     
    
     char* __cdecl fgets(
          char* _Buffer,
                               int   _MaxCount,
                            FILE* _Stream
        );

     
     int __cdecl _fileno(
          FILE* _Stream
        );

    
     int __cdecl _flushall(void);

      
     FILE* __cdecl fopen(
          char const* _FileName,
          char const* _Mode
        );


     
    
     int __cdecl fputc(
             int   _Character,
          FILE* _Stream
        );

    
     int __cdecl _fputchar(
          int _Character
        );

     
    
     int __cdecl fputs(
           char const* _Buffer,
          FILE*       _Stream
        );

    
     size_t __cdecl fread(
          void*  _Buffer,
                                                      size_t _ElementSize,
                                                      size_t _ElementCount,
                                                   FILE*  _Stream
        );

     
      
     FILE* __cdecl freopen(
           char const* _FileName,
           char const* _Mode,
          FILE*       _Stream
        );

     
     FILE* __cdecl _fsopen(
          char const* _FileName,
          char const* _Mode,
            int         _ShFlag
        );

     
    
     int __cdecl fsetpos(
          FILE*         _Stream,
             fpos_t const* _Position
        );

     
    
     int __cdecl fseek(
          FILE* _Stream,
             long  _Offset,
             int   _Origin
        );

     
    
     int __cdecl _fseeki64(
          FILE*   _Stream,
             __int64 _Offset,
             int     _Origin
        );

     
     
     long __cdecl ftell(
          FILE* _Stream
        );

     
     
     __int64 __cdecl _ftelli64(
          FILE* _Stream
        );

    
     size_t __cdecl fwrite(
          void const* _Buffer,
                                                    size_t      _ElementSize,
                                                    size_t      _ElementCount,
                                                 FILE*       _Stream
        );

     
     
     int __cdecl getc(
          FILE* _Stream
        );

     
     int __cdecl getchar(void);

     
     int __cdecl _getmaxstdio(void);

    

     
     int __cdecl _getw(
          FILE* _Stream
        );

     void __cdecl perror(
          char const* _ErrorMessage
        );

    

         
        
         int __cdecl _pclose(
              FILE* _Stream
            );

         
         FILE* __cdecl _popen(
              char const* _Command,
              char const* _Mode
            );

    

     
    
     int __cdecl putc(
             int   _Character,
          FILE* _Stream
        );

    
     int __cdecl putchar(
          int _Character
        );

    
     int __cdecl puts(
          char const* _Buffer
        );

     
    
     int __cdecl _putw(
             int   _Word,
          FILE* _Stream
        );

     int __cdecl remove(
          char const* _FileName
        );

     
     int __cdecl rename(
          char const* _OldFileName,
          char const* _NewFileName
        );

     int __cdecl _unlink(
          char const* _FileName
        );

    

        
         int __cdecl unlink(
              char const* _FileName
            );

    

     void __cdecl rewind(
          FILE* _Stream
        );

    
     int __cdecl _rmtmp(void);

    
     void __cdecl setbuf(
                                                      FILE* _Stream,
            char* _Buffer
        );

    
     int __cdecl _setmaxstdio(
          int _Maximum
        );

     
    
     int __cdecl setvbuf(
                               FILE*  _Stream,
            char*  _Buffer,
                                  int    _Mode,
                                  size_t _Size
        );

    




     
      char* __cdecl _tempnam(
          char const* _DirectoryName,
          char const* _FilePrefix
        );

    



      
     FILE* __cdecl tmpfile(void);

    



     
    
     int __cdecl ungetc(
             int   _Character,
          FILE* _Stream
        );



    
    
    
    
    
     void __cdecl _lock_file(
          FILE* _Stream
        );

     void __cdecl _unlock_file(
          FILE* _Stream
        );

     
    
     int __cdecl _fclose_nolock(
          FILE* _Stream
        );

     
    
     int __cdecl _fflush_nolock(
          FILE* _Stream
        );

     
    
     int __cdecl _fgetc_nolock(
          FILE* _Stream
        );

     
    
     int __cdecl _fputc_nolock(
             int   _Character,
          FILE* _Stream
        );

    
     size_t __cdecl _fread_nolock(
          void*  _Buffer,
                                                      size_t _ElementSize,
                                                      size_t _ElementCount,
                                                   FILE*  _Stream
        );

    
     
     size_t __cdecl _fread_nolock_s(
          void*  _Buffer,
                              size_t _BufferSize,
                                                                      size_t _ElementSize,
                                                                      size_t _ElementCount,
                                                                   FILE*  _Stream
        );

    
     int __cdecl _fseek_nolock(
          FILE* _Stream,
             long  _Offset,
             int   _Origin
        );

    
     int __cdecl _fseeki64_nolock(
          FILE*   _Stream,
             __int64 _Offset,
             int     _Origin
        );

     
     long __cdecl _ftell_nolock(
          FILE* _Stream
        );

     
     __int64 __cdecl _ftelli64_nolock(
          FILE* _Stream
        );

    
     size_t __cdecl _fwrite_nolock(
          void const* _Buffer,
                                                    size_t      _ElementSize,
                                                    size_t      _ElementCount,
                                                 FILE*       _Stream
        );

    
     int __cdecl _getc_nolock(
          FILE* _Stream
        );

    
     int __cdecl _putc_nolock(
             int   _Character,
          FILE* _Stream
        );

    
     int __cdecl _ungetc_nolock(
             int   _Character,
          FILE* _Stream
        );

    
    
    
    



    


















     int* __cdecl __p__commode(void);

    


        
    



    
    



    
    
    
    
    
     int __cdecl __stdio_common_vfprintf(
                                             unsigned __int64 _Options,
                                          FILE*            _Stream,
            char const*      _Format,
                                         _locale_t        _Locale,
                                                va_list          _ArgList
        );

     int __cdecl __stdio_common_vfprintf_s(
                                             unsigned __int64 _Options,
                                          FILE*            _Stream,
            char const*      _Format,
                                         _locale_t        _Locale,
                                                va_list          _ArgList
        );

     
     int __cdecl __stdio_common_vfprintf_p(
                                             unsigned __int64 _Options,
                                          FILE*            _Stream,
            char const*      _Format,
                                         _locale_t        _Locale,
                                                va_list          _ArgList
        );

    
    __inline int __cdecl _vfprintf_l(
           FILE*       const _Stream,
            char const* const _Format,
          _locale_t   const _Locale,
                 va_list           _ArgList
        )
    


    {
        return __stdio_common_vfprintf((*__local_stdio_printf_options()), _Stream, _Format, _Locale, _ArgList);
    }
    

    
    __inline int __cdecl vfprintf(
                                FILE*       const _Stream,
            char const* const _Format,
                                      va_list           _ArgList
        )
    


    {
        return _vfprintf_l(_Stream, _Format, ((void *)0), _ArgList);
    }
    

    
    __inline int __cdecl _vfprintf_s_l(
           FILE*       const _Stream,
            char const* const _Format,
          _locale_t   const _Locale,
                 va_list           _ArgList
        )
    


    {
        return __stdio_common_vfprintf_s((*__local_stdio_printf_options()), _Stream, _Format, _Locale, _ArgList);
    }
    

    

        
        __inline int __cdecl vfprintf_s(
                                    FILE*       const _Stream,
                char const* const _Format,
                                          va_list           _ArgList
            )
    


        {
            return _vfprintf_s_l(_Stream, _Format, ((void *)0), _ArgList);
        }
    

    

    
    __inline int __cdecl _vfprintf_p_l(
           FILE*       const _Stream,
            char const* const _Format,
          _locale_t   const _Locale,
                 va_list           _ArgList
        )
    


    {
        return __stdio_common_vfprintf_p((*__local_stdio_printf_options()), _Stream, _Format, _Locale, _ArgList);
    }
    

    
    __inline int __cdecl _vfprintf_p(
                                FILE*       const _Stream,
            char const* const _Format,
                                      va_list           _ArgList
        )
    


    {
        return _vfprintf_p_l(_Stream, _Format, ((void *)0), _ArgList);
    }
    

    
    __inline int __cdecl _vprintf_l(
            char const* const _Format,
                                         _locale_t   const _Locale,
                                                va_list           _ArgList
        )
    


    {
        return _vfprintf_l((__acrt_iob_func(1)), _Format, _Locale, _ArgList);
    }
    

    
    __inline int __cdecl vprintf(
            char const* const _Format,
                                      va_list           _ArgList
        )
    


    {
        return _vfprintf_l((__acrt_iob_func(1)), _Format, ((void *)0), _ArgList);
    }
    

    
    __inline int __cdecl _vprintf_s_l(
            char const* const _Format,
                                         _locale_t   const _Locale,
                                                va_list           _ArgList
        )
    


    {
        return _vfprintf_s_l((__acrt_iob_func(1)), _Format, _Locale, _ArgList);
    }
    

    

        
        __inline int __cdecl vprintf_s(
                char const* const _Format,
                                          va_list           _ArgList
            )
    


        {
            return _vfprintf_s_l((__acrt_iob_func(1)), _Format, ((void *)0), _ArgList);
        }
    

    

    
    __inline int __cdecl _vprintf_p_l(
            char const* const _Format,
                                         _locale_t   const _Locale,
                                                va_list           _ArgList
        )
    


    {
        return _vfprintf_p_l((__acrt_iob_func(1)), _Format, _Locale, _ArgList);
    }
    

    
    __inline int __cdecl _vprintf_p(
            char const* const _Format,
                                      va_list           _ArgList
        )
    


    {
        return _vfprintf_p_l((__acrt_iob_func(1)), _Format, ((void *)0), _ArgList);
    }
    

    
    __inline int __cdecl _fprintf_l(
                                          FILE*       const _Stream,
            char const* const _Format,
                                         _locale_t   const _Locale,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Locale)) + ((sizeof(_Locale) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vfprintf_l(_Stream, _Format, _Locale, _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

    
    __inline int __cdecl fprintf(
                                FILE*       const _Stream,
            char const* const _Format,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Format)) + ((sizeof(_Format) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vfprintf_l(_Stream, _Format, ((void *)0), _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

     int __cdecl _set_printf_count_output(
          int _Value
        );

     int __cdecl _get_printf_count_output(void);

    
    __inline int __cdecl _fprintf_s_l(
                                          FILE*       const _Stream,
            char const* const _Format,
                                         _locale_t   const _Locale,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Locale)) + ((sizeof(_Locale) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vfprintf_s_l(_Stream, _Format, _Locale, _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

    

        
        __inline int __cdecl fprintf_s(
                                    FILE*       const _Stream,
                char const* const _Format,
            ...)
    


        {
            int _Result;
            va_list _ArgList;
            ((void)(_ArgList = (va_list)(&(_Format)) + ((sizeof(_Format) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
            _Result = _vfprintf_s_l(_Stream, _Format, ((void *)0), _ArgList);
            ((void)(_ArgList = (va_list)0));
            return _Result;
        }
    

    

    
    __inline int __cdecl _fprintf_p_l(
                                          FILE*       const _Stream,
            char const* const _Format,
                                         _locale_t   const _Locale,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Locale)) + ((sizeof(_Locale) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vfprintf_p_l(_Stream, _Format, _Locale, _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

    
    __inline int __cdecl _fprintf_p(
                                FILE*       const _Stream,
            char const* const _Format,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Format)) + ((sizeof(_Format) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vfprintf_p_l(_Stream, _Format, ((void *)0), _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

    
    __inline int __cdecl _printf_l(
            char const* const _Format,
                                         _locale_t   const _Locale,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Locale)) + ((sizeof(_Locale) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vfprintf_l((__acrt_iob_func(1)), _Format, _Locale, _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

    
    __inline int __cdecl printf(
            char const* const _Format,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Format)) + ((sizeof(_Format) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vfprintf_l((__acrt_iob_func(1)), _Format, ((void *)0), _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

    
    __inline int __cdecl _printf_s_l(
            char const* const _Format,
                                         _locale_t   const _Locale,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Locale)) + ((sizeof(_Locale) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vfprintf_s_l((__acrt_iob_func(1)), _Format, _Locale, _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

    

        
        __inline int __cdecl printf_s(
                char const* const _Format,
            ...)
    


        {
            int _Result;
            va_list _ArgList;
            ((void)(_ArgList = (va_list)(&(_Format)) + ((sizeof(_Format) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
            _Result = _vfprintf_s_l((__acrt_iob_func(1)), _Format, ((void *)0), _ArgList);
            ((void)(_ArgList = (va_list)0));
            return _Result;
        }
    

    

    
    __inline int __cdecl _printf_p_l(
            char const* const _Format,
                                         _locale_t   const _Locale,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Locale)) + ((sizeof(_Locale) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vfprintf_p_l((__acrt_iob_func(1)), _Format, _Locale, _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

    
    __inline int __cdecl _printf_p(
            char const* const _Format,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Format)) + ((sizeof(_Format) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vfprintf_p_l((__acrt_iob_func(1)), _Format, ((void *)0), _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    


    
    
    
    
    
     int __cdecl __stdio_common_vfscanf(
                                            unsigned __int64 _Options,
                                         FILE*            _Stream,
            char const*      _Format,
                                        _locale_t        _Locale,
                                               va_list          _Arglist
        );

    
    __inline int __cdecl _vfscanf_l(
                                FILE*       const _Stream,
            char const* const _Format,
                               _locale_t   const _Locale,
                                      va_list           _ArgList
        )
    


    {
        return __stdio_common_vfscanf(
            (*__local_stdio_scanf_options ()),
            _Stream, _Format, _Locale, _ArgList);
    }
    

    
    __inline int __cdecl vfscanf(
                                FILE*       const _Stream,
            char const* const _Format,
                                      va_list           _ArgList
        )
    


    {
        return _vfscanf_l(_Stream, _Format, ((void *)0), _ArgList);
    }
    

    
    __inline int __cdecl _vfscanf_s_l(
                                FILE*       const _Stream,
            char const* const _Format,
                               _locale_t   const _Locale,
                                      va_list           _ArgList
        )
    


    {
        return __stdio_common_vfscanf(
            (*__local_stdio_scanf_options ()) | (1ULL << 0),
            _Stream, _Format, _Locale, _ArgList);
    }
    


    

        
        __inline int __cdecl vfscanf_s(
                                    FILE*       const _Stream,
                char const* const _Format,
                                          va_list           _ArgList
            )
    


        {
            return _vfscanf_s_l(_Stream, _Format, ((void *)0), _ArgList);
        }
    

    

    
    __inline int __cdecl _vscanf_l(
            char const* const _Format,
                               _locale_t   const _Locale,
                                      va_list           _ArgList
        )
    


    {
        return _vfscanf_l((__acrt_iob_func(0)), _Format, _Locale, _ArgList);
    }
    

    
    __inline int __cdecl vscanf(
            char const* const _Format,
                                      va_list           _ArgList
        )
    


    {
        return _vfscanf_l((__acrt_iob_func(0)), _Format, ((void *)0), _ArgList);
    }
    

    
    __inline int __cdecl _vscanf_s_l(
            char const* const _Format,
                               _locale_t   const _Locale,
                                      va_list           _ArgList
        )
    


    {
        return _vfscanf_s_l((__acrt_iob_func(0)), _Format, _Locale, _ArgList);
    }
    

    

        
        __inline int __cdecl vscanf_s(
                char const* const _Format,
                                          va_list           _ArgList
            )
    


        {
            return _vfscanf_s_l((__acrt_iob_func(0)), _Format, ((void *)0), _ArgList);
        }
    

    

     
    __inline int __cdecl _fscanf_l(
                                         FILE*       const _Stream,
            char const* const _Format,
                                        _locale_t   const _Locale,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Locale)) + ((sizeof(_Locale) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vfscanf_l(_Stream, _Format, _Locale, _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

      
    __inline int __cdecl fscanf(
                               FILE*       const _Stream,
            char const* const _Format,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Format)) + ((sizeof(_Format) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vfscanf_l(_Stream, _Format, ((void *)0), _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

    
    __inline int __cdecl _fscanf_s_l(
                                           FILE*       const _Stream,
            char const* const _Format,
                                          _locale_t   const _Locale,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Locale)) + ((sizeof(_Locale) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vfscanf_s_l(_Stream, _Format, _Locale, _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

    

        
        __inline int __cdecl fscanf_s(
                                     FILE*       const _Stream,
                char const* const _Format,
            ...)
    


        {
            int _Result;
            va_list _ArgList;
            ((void)(_ArgList = (va_list)(&(_Format)) + ((sizeof(_Format) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
            _Result = _vfscanf_s_l(_Stream, _Format, ((void *)0), _ArgList);
            ((void)(_ArgList = (va_list)0));
            return _Result;
        }
    

    

     
    __inline int __cdecl _scanf_l(
            char const* const _Format,
                                        _locale_t   const _Locale,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Locale)) + ((sizeof(_Locale) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vfscanf_l((__acrt_iob_func(0)), _Format, _Locale, _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

      
    __inline int __cdecl scanf(
            char const* const _Format,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Format)) + ((sizeof(_Format) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vfscanf_l((__acrt_iob_func(0)), _Format, ((void *)0), _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

    
    __inline int __cdecl _scanf_s_l(
            char const* const _Format,
                                          _locale_t   const _Locale,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Locale)) + ((sizeof(_Locale) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vfscanf_s_l((__acrt_iob_func(0)), _Format, _Locale, _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

    

        
        __inline int __cdecl scanf_s(
                char const* const _Format,
            ...)
    


        {
            int _Result;
            va_list _ArgList;
            ((void)(_ArgList = (va_list)(&(_Format)) + ((sizeof(_Format) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
            _Result = _vfscanf_s_l((__acrt_iob_func(0)), _Format, ((void *)0), _ArgList);
            ((void)(_ArgList = (va_list)0));
            return _Result;
        }
    

    



    
    
    
    
    
     
     int __cdecl __stdio_common_vsprintf(
                                             unsigned __int64 _Options,
                 char*            _Buffer,
                                             size_t           _BufferCount,
            char const*      _Format,
                                         _locale_t        _Locale,
                                                va_list          _ArgList
        );

     
     int __cdecl __stdio_common_vsprintf_s(
                                             unsigned __int64 _Options,
                     char*            _Buffer,
                                             size_t           _BufferCount,
            char const*      _Format,
                                         _locale_t        _Locale,
                                                va_list          _ArgList
        );

     
     int __cdecl __stdio_common_vsnprintf_s(
                                             unsigned __int64 _Options,
                 char*            _Buffer,
                                             size_t           _BufferCount,
                                             size_t           _MaxCount,
            char const*      _Format,
                                         _locale_t        _Locale,
                                                va_list          _ArgList
        );

     
     int __cdecl __stdio_common_vsprintf_p(
                                             unsigned __int64 _Options,
                     char*            _Buffer,
                                             size_t           _BufferCount,
            char const*      _Format,
                                         _locale_t        _Locale,
                                                va_list          _ArgList
        );

     
     
    __inline int __cdecl _vsnprintf_l(
            char*       const _Buffer,
                                                  size_t      const _BufferCount,
                 char const* const _Format,
                                              _locale_t   const _Locale,
                                                     va_list           _ArgList
        )
    


    {
        int const _Result = __stdio_common_vsprintf(
            (*__local_stdio_printf_options()) | (1ULL << 0),
            _Buffer, _BufferCount, _Format, _Locale, _ArgList);

        return _Result < 0 ? -1 : _Result;
    }
    

     
    
    __inline int __cdecl _vsnprintf(
            char*       const _Buffer,
                                                 size_t      const _BufferCount,
                          char const* const _Format,
                                                    va_list           _ArgList
        )
    


    {
        return _vsnprintf_l(_Buffer, _BufferCount, _Format, ((void *)0), _ArgList);
    }
    

    










     
    
    __inline int __cdecl vsnprintf(
           char*       const _Buffer,
                                                       size_t      const _BufferCount,
                                char const* const _Format,
                                                          va_list           _ArgList
        )
    


    {
        int const _Result = __stdio_common_vsprintf(
            (*__local_stdio_printf_options()) | (1ULL << 1),
            _Buffer, _BufferCount, _Format, ((void *)0), _ArgList);

        return _Result < 0 ? -1 : _Result;
    }
    

     
     
    __inline int __cdecl _vsprintf_l(
           char*       const _Buffer,
                                    char const* const _Format,
                                  _locale_t   const _Locale,
                                         va_list           _ArgList
        )
    


    {
        return _vsnprintf_l(_Buffer, (size_t)-1, _Format, _Locale, _ArgList);
    }
    

     
     
    __inline int __cdecl vsprintf(
           char*       const _Buffer,
               char const* const _Format,
                                         va_list           _ArgList
        )
    


    {
        return _vsnprintf_l(_Buffer, (size_t)-1, _Format, ((void *)0), _ArgList);
    }
    

     
    
    __inline int __cdecl _vsprintf_s_l(
           char*       const _Buffer,
                                                   size_t      const _BufferCount,
                  char const* const _Format,
                                               _locale_t   const _Locale,
                                                      va_list           _ArgList
        )
    


    {
        int const _Result = __stdio_common_vsprintf_s(
            (*__local_stdio_printf_options()),
            _Buffer, _BufferCount, _Format, _Locale, _ArgList);

        return _Result < 0 ? -1 : _Result;
    }
    

    

         
        
        __inline int __cdecl vsprintf_s(
               char*       const _Buffer,
                                                       size_t      const _BufferCount,
                                char const* const _Format,
                                                          va_list           _ArgList
            )
    


        {
            return _vsprintf_s_l(_Buffer, _BufferCount, _Format, ((void *)0), _ArgList);
        }
    

        

    

     
    
    __inline int __cdecl _vsprintf_p_l(
           char*       const _Buffer,
                                                   size_t      const _BufferCount,
                  char const* const _Format,
                                               _locale_t   const _Locale,
                                                      va_list           _ArgList
        )
    


    {
        int const _Result = __stdio_common_vsprintf_p(
            (*__local_stdio_printf_options()),
            _Buffer, _BufferCount, _Format, _Locale, _ArgList);

        return _Result < 0 ? -1 : _Result;
    }
    

     
    
    __inline int __cdecl _vsprintf_p(
           char*       const _Buffer,
                                                   size_t      const _BufferCount,
                            char const* const _Format,
                                                      va_list           _ArgList
        )
    


    {
        return _vsprintf_p_l(_Buffer, _BufferCount, _Format, ((void *)0), _ArgList);
    }
    

     
    
    __inline int __cdecl _vsnprintf_s_l(
           char*       const _Buffer,
                                                       size_t      const _BufferCount,
                                                       size_t      const _MaxCount,
                      char const* const _Format,
                                                   _locale_t   const _Locale,
                                                          va_list          _ArgList
        )
    


    {
        int const _Result = __stdio_common_vsnprintf_s(
            (*__local_stdio_printf_options()),
            _Buffer, _BufferCount, _MaxCount, _Format, _Locale, _ArgList);

        return _Result < 0 ? -1 : _Result;
    }
    

     
    
    __inline int __cdecl _vsnprintf_s(
           char*       const _Buffer,
                                                       size_t      const _BufferCount,
                                                       size_t      const _MaxCount,
                                char const* const _Format,
                                                          va_list           _ArgList
        )
    


    {
        return _vsnprintf_s_l(_Buffer, _BufferCount, _MaxCount, _Format, ((void *)0), _ArgList);
    }
    

    

    

         
        
        __inline int __cdecl vsnprintf_s(
               char*       const _Buffer,
                                                           size_t      const _BufferCount,
                                                           size_t      const _MaxCount,
                                    char const* const _Format,
                                                              va_list           _ArgList
            )
    


        {
            return _vsnprintf_s_l(_Buffer, _BufferCount, _MaxCount, _Format, ((void *)0), _ArgList);
        }
    

        

    

    
    __inline int __cdecl _vscprintf_l(
            char const* const _Format,
                                         _locale_t   const _Locale,
                                                va_list           _ArgList
        )
    


    {
        int const _Result = __stdio_common_vsprintf(
            (*__local_stdio_printf_options()) | (1ULL << 1),
            ((void *)0), 0, _Format, _Locale, _ArgList);

        return _Result < 0 ? -1 : _Result;
    }
    

     
    __inline int __cdecl _vscprintf(
            char const* const _Format,
                                      va_list           _ArgList
        )
    


    {
        return _vscprintf_l(_Format, ((void *)0), _ArgList);
    }
    

    
    __inline int __cdecl _vscprintf_p_l(
            char const* const _Format,
                                         _locale_t   const _Locale,
                                                va_list           _ArgList
        )
    


    {
        int const _Result = __stdio_common_vsprintf_p(
            (*__local_stdio_printf_options()) | (1ULL << 1),
            ((void *)0), 0, _Format, _Locale, _ArgList);

        return _Result < 0 ? -1 : _Result;
    }
    

     
    __inline int __cdecl _vscprintf_p(
            char const* const _Format,
                                      va_list           _ArgList
        )
    


    {
        return _vscprintf_p_l(_Format, ((void *)0), _ArgList);
    }
    

    
    __inline int __cdecl _vsnprintf_c_l(
                   char*       const _Buffer,
                                             size_t      const _BufferCount,
            char const* const _Format,
                                         _locale_t   const _Locale,
                                                va_list           _ArgList
        )
    


    {
        int const _Result = __stdio_common_vsprintf(
            (*__local_stdio_printf_options()),
            _Buffer, _BufferCount, _Format, _Locale, _ArgList);

        return _Result < 0 ? -1 : _Result;
    }
    

     
    
    __inline int __cdecl _vsnprintf_c(
          char*       const _Buffer,
                                    size_t      const _BufferCount,
             char const* const _Format,
                                       va_list           _ArgList
        )
    


    {
        return _vsnprintf_c_l(_Buffer, _BufferCount, _Format, ((void *)0), _ArgList);
    }
    

     
     
    __inline int __cdecl _sprintf_l(
                  char*       const _Buffer,
            char const* const _Format,
                                         _locale_t   const _Locale,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Locale)) + ((sizeof(_Locale) + sizeof(int) - 1) & ~(sizeof(int) - 1))));

        _Result = _vsprintf_l(_Buffer, _Format, _Locale, _ArgList);

        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

     
    
    __inline int __cdecl sprintf(
           char*       const _Buffer,
               char const* const _Format,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Format)) + ((sizeof(_Format) + sizeof(int) - 1) & ~(sizeof(int) - 1))));

        _Result = _vsprintf_l(_Buffer, _Format, ((void *)0), _ArgList);

        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

    

     
    
    __inline int __cdecl _sprintf_s_l(
           char*       const _Buffer,
                                                   size_t      const _BufferCount,
                  char const* const _Format,
                                               _locale_t   const _Locale,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Locale)) + ((sizeof(_Locale) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vsprintf_s_l(_Buffer, _BufferCount, _Format, _Locale, _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

    

         
        
        __inline int __cdecl sprintf_s(
               char*       const _Buffer,
                                                       size_t      const _BufferCount,
                                char const* const _Format,
            ...)
    


        {
            int _Result;
            va_list _ArgList;
            ((void)(_ArgList = (va_list)(&(_Format)) + ((sizeof(_Format) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
            _Result = _vsprintf_s_l(_Buffer, _BufferCount, _Format, ((void *)0), _ArgList);
            ((void)(_ArgList = (va_list)0));
            return _Result;
        }
    

    

    

     
    
    __inline int __cdecl _sprintf_p_l(
           char*       const _Buffer,
                                                   size_t      const _BufferCount,
                  char const* const _Format,
                                               _locale_t   const _Locale,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Locale)) + ((sizeof(_Locale) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vsprintf_p_l(_Buffer, _BufferCount, _Format, _Locale, _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

     
    
    __inline int __cdecl _sprintf_p(
           char*       const _Buffer,
                                                   size_t      const _BufferCount,
                            char const* const _Format,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Format)) + ((sizeof(_Format) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vsprintf_p_l(_Buffer, _BufferCount, _Format, ((void *)0), _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

     
     
    __inline int __cdecl _snprintf_l(
            char*       const _Buffer,
                                                  size_t      const _BufferCount,
                 char const* const _Format,
                                              _locale_t   const _Locale,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Locale)) + ((sizeof(_Locale) + sizeof(int) - 1) & ~(sizeof(int) - 1))));

        _Result = _vsnprintf_l(_Buffer, _BufferCount, _Format, _Locale, _ArgList);

        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

    










     
    
    __inline int __cdecl snprintf(
           char*       const _Buffer,
                                                       size_t      const _BufferCount,
                                char const* const _Format,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Format)) + ((sizeof(_Format) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = vsnprintf(_Buffer, _BufferCount, _Format, _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

     
    
    __inline int __cdecl _snprintf(
            char*       const _Buffer,
                                                  size_t      const _BufferCount,
                           char const* const _Format,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Format)) + ((sizeof(_Format) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vsnprintf(_Buffer, _BufferCount, _Format, _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

    

     
    
    __inline int __cdecl _snprintf_c_l(
                   char*       const _Buffer,
                                             size_t      const _BufferCount,
            char const* const _Format,
                                         _locale_t   const _Locale,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Locale)) + ((sizeof(_Locale) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vsnprintf_c_l(_Buffer, _BufferCount, _Format, _Locale, _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

     
    
    __inline int __cdecl _snprintf_c(
          char*       const _Buffer,
                                    size_t      const _BufferCount,
             char const* const _Format,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Format)) + ((sizeof(_Format) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vsnprintf_c_l(_Buffer, _BufferCount, _Format, ((void *)0), _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

     
    
    __inline int __cdecl _snprintf_s_l(
           char*       const _Buffer,
                                                       size_t      const _BufferCount,
                                                       size_t      const _MaxCount,
                      char const* const _Format,
                                                   _locale_t   const _Locale,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Locale)) + ((sizeof(_Locale) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vsnprintf_s_l(_Buffer, _BufferCount, _MaxCount, _Format, _Locale, _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

     
    
    __inline int __cdecl _snprintf_s(
           char*       const _Buffer,
                                                       size_t      const _BufferCount,
                                                       size_t      const _MaxCount,
                                char const* const _Format,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Format)) + ((sizeof(_Format) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vsnprintf_s_l(_Buffer, _BufferCount, _MaxCount, _Format, ((void *)0), _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

    

    
    __inline int __cdecl _scprintf_l(
            char const* const _Format,
                                         _locale_t   const _Locale,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Locale)) + ((sizeof(_Locale) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vscprintf_l(_Format, _Locale, _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

     
    __inline int __cdecl _scprintf(
            char const* const _Format,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Format)) + ((sizeof(_Format) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vscprintf_l(_Format, ((void *)0), _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

    
    __inline int __cdecl _scprintf_p_l(
            char const* const _Format,
                                         _locale_t   const _Locale,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Locale)) + ((sizeof(_Locale) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vscprintf_p_l(_Format, _Locale, _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

     
    __inline int __cdecl _scprintf_p(
            char const* const _Format,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Format)) + ((sizeof(_Format) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vscprintf_p(_Format, _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

    
    
    
    
    
     int __cdecl __stdio_common_vsscanf(
                                            unsigned __int64 _Options,
                  char const*      _Buffer,
                                            size_t           _BufferCount,
            char const*      _Format,
                                        _locale_t        _Locale,
                                               va_list          _ArgList
        );

    
    __inline int __cdecl _vsscanf_l(
                                 char const* const _Buffer,
            char const* const _Format,
                               _locale_t   const _Locale,
                                      va_list           _ArgList
        )
    


    {
        return __stdio_common_vsscanf(
            (*__local_stdio_scanf_options ()),
            _Buffer, (size_t)-1, _Format, _Locale, _ArgList);
    }
    

    
    __inline int __cdecl vsscanf(
                                 char const* const _Buffer,
            char const* const _Format,
                                      va_list           _ArgList
        )
    


    {
        return _vsscanf_l(_Buffer, _Format, ((void *)0), _ArgList);
    }
    

    
    __inline int __cdecl _vsscanf_s_l(
                                 char const* const _Buffer,
            char const* const _Format,
                               _locale_t   const _Locale,
                                      va_list           _ArgList
        )
    


    {
        return __stdio_common_vsscanf(
            (*__local_stdio_scanf_options ()) | (1ULL << 0),
            _Buffer, (size_t)-1, _Format, _Locale, _ArgList);
    }
    

    

        #pragma warning(push)
        #pragma warning(disable: 6530) 

        
        __inline int __cdecl vsscanf_s(
                                     char const* const _Buffer,
                char const* const _Format,
                                          va_list           _ArgList
            )
    


        {
            return _vsscanf_s_l(_Buffer, _Format, ((void *)0), _ArgList);
        }
    

        

        #pragma warning(pop)

    

     
    __inline int __cdecl _sscanf_l(
                                          char const* const _Buffer,
            char const* const _Format,
                                        _locale_t   const _Locale,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Locale)) + ((sizeof(_Locale) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vsscanf_l(_Buffer, _Format, _Locale, _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

      
    __inline int __cdecl sscanf(
                                char const* const _Buffer,
            char const* const _Format,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Format)) + ((sizeof(_Format) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vsscanf_l(_Buffer, _Format, ((void *)0), _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

    
    __inline int __cdecl _sscanf_s_l(
                                            char const* const _Buffer,
            char const* const _Format,
                                          _locale_t   const _Locale,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Locale)) + ((sizeof(_Locale) + sizeof(int) - 1) & ~(sizeof(int) - 1))));
        _Result = _vsscanf_s_l(_Buffer, _Format, _Locale, _ArgList);
        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

    

        
        __inline int __cdecl sscanf_s(
                                      char const* const _Buffer,
                char const* const _Format,
            ...)
    


        {
            int _Result;
            va_list _ArgList;
            ((void)(_ArgList = (va_list)(&(_Format)) + ((sizeof(_Format) + sizeof(int) - 1) & ~(sizeof(int) - 1))));

            _Result = vsscanf_s(_Buffer, _Format, _ArgList);

            ((void)(_ArgList = (va_list)0));
            return _Result;
        }
    

    

    #pragma warning(push)
    #pragma warning(disable: 6530) 

     
    __inline int __cdecl _snscanf_l(
            char const* const _Buffer,
                                            size_t      const _BufferCount,
            char const* const _Format,
                                        _locale_t   const _Locale,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Locale)) + ((sizeof(_Locale) + sizeof(int) - 1) & ~(sizeof(int) - 1))));

        _Result = __stdio_common_vsscanf(
            (*__local_stdio_scanf_options ()),
            _Buffer, _BufferCount, _Format, _Locale, _ArgList);

        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

     
    __inline int __cdecl _snscanf(
            char const* const _Buffer,
                                            size_t      const _BufferCount,
                      char const* const _Format,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Format)) + ((sizeof(_Format) + sizeof(int) - 1) & ~(sizeof(int) - 1))));

        _Result = __stdio_common_vsscanf(
            (*__local_stdio_scanf_options ()),
            _Buffer, _BufferCount, _Format, ((void *)0), _ArgList);

        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    


    
    __inline int __cdecl _snscanf_s_l(
              char const* const _Buffer,
                                              size_t      const _BufferCount,
            char const* const _Format,
                                          _locale_t   const _Locale,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Locale)) + ((sizeof(_Locale) + sizeof(int) - 1) & ~(sizeof(int) - 1))));

        _Result = __stdio_common_vsscanf(
            (*__local_stdio_scanf_options ()) | (1ULL << 0),
            _Buffer, _BufferCount, _Format, _Locale, _ArgList);

        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

    
    __inline int __cdecl _snscanf_s(
            char const* const _Buffer,
                                            size_t      const _BufferCount,
                    char const* const _Format,
        ...)
    


    {
        int _Result;
        va_list _ArgList;
        ((void)(_ArgList = (va_list)(&(_Format)) + ((sizeof(_Format) + sizeof(int) - 1) & ~(sizeof(int) - 1))));

        _Result = __stdio_common_vsscanf(
            (*__local_stdio_scanf_options ()) | (1ULL << 0),
            _Buffer, _BufferCount, _Format, ((void *)0), _ArgList);

        ((void)(_ArgList = (va_list)0));
        return _Result;
    }
    

    #pragma warning(pop)

    





    
    
    
    
    
    

        

        




        
         char* __cdecl tempnam(
              char const* _Directory,
              char const* _FilePrefix
            );

        



         
              
         
              
         
         
              
         
              

    






#pragma warning(pop) 








typedef struct ecs_time_t {
    uint32_t sec;                                 
    uint32_t nanosec;                             
} ecs_time_t;


__declspec(dllimport) extern int64_t ecs_os_api_malloc_count;  
__declspec(dllimport) extern int64_t ecs_os_api_realloc_count; 
__declspec(dllimport) extern int64_t ecs_os_api_calloc_count;  
__declspec(dllimport) extern int64_t ecs_os_api_free_count;    










typedef uintptr_t ecs_os_thread_t;                 
typedef uintptr_t ecs_os_cond_t;                   
typedef uintptr_t ecs_os_mutex_t;                  
typedef uintptr_t ecs_os_dl_t;                     
typedef uintptr_t ecs_os_sock_t;                   


typedef uint64_t ecs_os_thread_id_t;


typedef void (*ecs_os_proc_t)(void);


typedef
void (*ecs_os_api_init_t)(void);


typedef
void (*ecs_os_api_fini_t)(void);


typedef
void* (*ecs_os_api_malloc_t)(
    ecs_size_t size);


typedef
void (*ecs_os_api_free_t)(
    void *ptr);


typedef
void* (*ecs_os_api_realloc_t)(
    void *ptr,
    ecs_size_t size);


typedef
void* (*ecs_os_api_calloc_t)(
    ecs_size_t size);


typedef
char* (*ecs_os_api_strdup_t)(
    const char *str);


typedef
void* (*ecs_os_thread_callback_t)(
    void*);


typedef
ecs_os_thread_t (*ecs_os_api_thread_new_t)(
    ecs_os_thread_callback_t callback,
    void *param);


typedef
void* (*ecs_os_api_thread_join_t)(
    ecs_os_thread_t thread);


typedef
ecs_os_thread_id_t (*ecs_os_api_thread_self_t)(void);


typedef
ecs_os_thread_t (*ecs_os_api_task_new_t)(
    ecs_os_thread_callback_t callback,
    void *param);


typedef
void* (*ecs_os_api_task_join_t)(
    ecs_os_thread_t thread);



typedef
int32_t (*ecs_os_api_ainc_t)(
    int32_t *value);


typedef
int64_t (*ecs_os_api_lainc_t)(
    int64_t *value);



typedef
ecs_os_mutex_t (*ecs_os_api_mutex_new_t)(
    void);


typedef
void (*ecs_os_api_mutex_lock_t)(
    ecs_os_mutex_t mutex);


typedef
void (*ecs_os_api_mutex_unlock_t)(
    ecs_os_mutex_t mutex);


typedef
void (*ecs_os_api_mutex_free_t)(
    ecs_os_mutex_t mutex);



typedef
ecs_os_cond_t (*ecs_os_api_cond_new_t)(
    void);


typedef
void (*ecs_os_api_cond_free_t)(
    ecs_os_cond_t cond);


typedef
void (*ecs_os_api_cond_signal_t)(
    ecs_os_cond_t cond);


typedef
void (*ecs_os_api_cond_broadcast_t)(
    ecs_os_cond_t cond);


typedef
void (*ecs_os_api_cond_wait_t)(
    ecs_os_cond_t cond,
    ecs_os_mutex_t mutex);


typedef
void (*ecs_os_api_sleep_t)(
    int32_t sec,
    int32_t nanosec);


typedef
void (*ecs_os_api_enable_high_timer_resolution_t)(
    _Bool enable);


typedef
void (*ecs_os_api_get_time_t)(
    ecs_time_t *time_out);


typedef
uint64_t (*ecs_os_api_now_t)(void);








typedef
void (*ecs_os_api_log_t)(
    int32_t level,
    const char *file,
    int32_t line,
    const char *msg);


typedef
void (*ecs_os_api_abort_t)(
    void);


typedef
ecs_os_dl_t (*ecs_os_api_dlopen_t)(
    const char *libname);


typedef
ecs_os_proc_t (*ecs_os_api_dlproc_t)(
    ecs_os_dl_t lib,
    const char *procname);


typedef
void (*ecs_os_api_dlclose_t)(
    ecs_os_dl_t lib);


typedef
char* (*ecs_os_api_module_to_path_t)(
    const char *module_id);


typedef
FILE* (*ecs_os_api_fopen_t)(
    const char *file,
    const char *mode);


typedef
void (*ecs_os_api_fclose_t)(
    FILE *file);


typedef
size_t (*ecs_os_api_fread_t)(
    void *ptr,
    size_t size,
    size_t count,
    FILE *file);







typedef void (*ecs_os_api_perf_trace_t)(
    const char *filename,
    size_t line,
    const char *name);





typedef struct ecs_os_api_t {
    
    ecs_os_api_init_t init_;                       
    ecs_os_api_fini_t fini_;                       

    
    ecs_os_api_malloc_t malloc_;                   
    ecs_os_api_realloc_t realloc_;                 
    ecs_os_api_calloc_t calloc_;                   
    ecs_os_api_free_t free_;                       

    
    ecs_os_api_strdup_t strdup_;                   

    
    ecs_os_api_thread_new_t thread_new_;           
    ecs_os_api_thread_join_t thread_join_;         
    ecs_os_api_thread_self_t thread_self_;         

    
    ecs_os_api_thread_new_t task_new_;             
    ecs_os_api_thread_join_t task_join_;           

    
    ecs_os_api_ainc_t ainc_;                       
    ecs_os_api_ainc_t adec_;                       
    ecs_os_api_lainc_t lainc_;                     
    ecs_os_api_lainc_t ladec_;                     

    
    ecs_os_api_mutex_new_t mutex_new_;             
    ecs_os_api_mutex_free_t mutex_free_;           
    ecs_os_api_mutex_lock_t mutex_lock_;           
    ecs_os_api_mutex_lock_t mutex_unlock_;         

    
    ecs_os_api_cond_new_t cond_new_;               
    ecs_os_api_cond_free_t cond_free_;             
    ecs_os_api_cond_signal_t cond_signal_;         
    ecs_os_api_cond_broadcast_t cond_broadcast_;   
    ecs_os_api_cond_wait_t cond_wait_;             

    
    ecs_os_api_sleep_t sleep_;                     
    ecs_os_api_now_t now_;                         
    ecs_os_api_get_time_t get_time_;               

    
    ecs_os_api_log_t log_; 







    
    ecs_os_api_abort_t abort_;                     

    
    ecs_os_api_dlopen_t dlopen_;                   
    ecs_os_api_dlproc_t dlproc_;                   
    ecs_os_api_dlclose_t dlclose_;                 

    

    ecs_os_api_module_to_path_t module_to_dl_;     

    

    ecs_os_api_module_to_path_t module_to_etc_;    

    
    ecs_os_api_fopen_t fopen_;                     
    ecs_os_api_fclose_t fclose_;                   
    ecs_os_api_fread_t fread_;                     

    
    ecs_os_api_perf_trace_t perf_trace_push_; 
    ecs_os_api_perf_trace_t perf_trace_pop_;  

    int32_t log_level_;                            
    int32_t log_indent_;                           
    int32_t log_last_error_;                       
    int64_t log_last_timestamp_;                   

    ecs_flags32_t flags_;                          

    void *log_out_;                                

} ecs_os_api_t;


__declspec(dllimport)
extern ecs_os_api_t ecs_os_api;












__declspec(dllimport)
void ecs_os_init(void);




__declspec(dllimport)
void ecs_os_fini(void);







__declspec(dllimport)
void ecs_os_set_api(
    ecs_os_api_t *os_api);






__declspec(dllimport)
ecs_os_api_t ecs_os_get_api(void);







__declspec(dllimport)
void ecs_os_set_api_defaults(void);


















































































































































































__declspec(dllimport)
void ecs_os_dbg(
    const char *file, 
    int32_t line, 
    const char *msg);







__declspec(dllimport)
void ecs_os_trace(
    const char *file, 
    int32_t line, 
    const char *msg);







__declspec(dllimport)
void ecs_os_warn(
    const char *file, 
    int32_t line, 
    const char *msg);







__declspec(dllimport)
void ecs_os_err(
    const char *file, 
    int32_t line, 
    const char *msg);







__declspec(dllimport)
void ecs_os_fatal(
    const char *file, 
    int32_t line, 
    const char *msg);






__declspec(dllimport)
const char* ecs_os_strerror(
    int err);







__declspec(dllimport)
void ecs_os_strset(
    char **str, 
    const char *value);
















void ecs_os_perf_trace_push_(
    const char *file,
    size_t line,
    const char *name);







void ecs_os_perf_trace_pop_(
    const char *file,
    size_t line,
    const char *name);





__declspec(dllimport)
void ecs_sleepf(
    double t);
















__declspec(dllimport)
double ecs_time_measure(
    ecs_time_t *start);







__declspec(dllimport)
ecs_time_t ecs_time_sub(
    ecs_time_t t1,
    ecs_time_t t2);






__declspec(dllimport)
double ecs_time_to_double(
    ecs_time_t t);







__declspec(dllimport)
void* ecs_os_memdup(
    const void *src,
    ecs_size_t size);


__declspec(dllimport)
_Bool ecs_os_has_heap(void);


__declspec(dllimport)
_Bool ecs_os_has_threading(void);


__declspec(dllimport)
_Bool ecs_os_has_task_support(void);


__declspec(dllimport)
_Bool ecs_os_has_time(void);


__declspec(dllimport)
_Bool ecs_os_has_logging(void);


__declspec(dllimport)
_Bool ecs_os_has_dl(void);


__declspec(dllimport)
_Bool ecs_os_has_modules(void);




































typedef void (*ecs_run_action_t)(
    ecs_iter_t *it);







typedef void (*ecs_iter_action_t)(
    ecs_iter_t *it);








typedef _Bool (*ecs_iter_next_action_t)(
    ecs_iter_t *it);






typedef void (*ecs_iter_fini_action_t)(
    ecs_iter_t *it);


typedef int (*ecs_order_by_action_t)(
    ecs_entity_t e1,
    const void *ptr1,
    ecs_entity_t e2,
    const void *ptr2);


typedef void (*ecs_sort_table_action_t)(
    ecs_world_t* world,
    ecs_table_t* table,
    ecs_entity_t* entities,
    void* ptr,
    int32_t size,
    int32_t lo,
    int32_t hi,
    ecs_order_by_action_t order_by);


typedef uint64_t (*ecs_group_by_action_t)(
    ecs_world_t *world,
    ecs_table_t *table,
    ecs_id_t group_id,
    void *ctx);


typedef void* (*ecs_group_create_action_t)(
    ecs_world_t *world,
    uint64_t group_id,
    void *group_by_ctx); 


typedef void (*ecs_group_delete_action_t)(
    ecs_world_t *world,
    uint64_t group_id,
    void *group_ctx,     
    void *group_by_ctx); 


typedef void (*ecs_module_action_t)(
    ecs_world_t *world);


typedef void (*ecs_fini_action_t)(
    ecs_world_t *world,
    void *ctx);


typedef void (*ecs_ctx_free_t)(
    void *ctx);


typedef int (*ecs_compare_action_t)(
    const void *ptr1,
    const void *ptr2);


typedef uint64_t (*ecs_hash_value_action_t)(
    const void *ptr);


typedef void (*ecs_xtor_t)(
    void *ptr,
    int32_t count,
    const ecs_type_info_t *type_info);


typedef void (*ecs_copy_t)(
    void *dst_ptr,
    const void *src_ptr,
    int32_t count,
    const ecs_type_info_t *type_info);


typedef void (*ecs_move_t)(
    void *dst_ptr,
    void *src_ptr,
    int32_t count,
    const ecs_type_info_t *type_info);


typedef int (*ecs_cmp_t)(
    const void *a_ptr,
    const void *b_ptr,
    const ecs_type_info_t *type_info);


typedef _Bool (*ecs_equals_t)(
    const void *a_ptr,
    const void *b_ptr,
    const ecs_type_info_t *type_info);




typedef _Bool (*ecs_on_validate_t)(
    ecs_world_t *world,
    ecs_entity_t entity,
    void *ptr);


typedef void (*flecs_poly_dtor_t)(
    ecs_poly_t *poly);











typedef enum ecs_inout_kind_t {
    EcsInOutDefault,  
    EcsInOutNone,     
    EcsInOutFilter,   
    EcsInOut,         
    EcsIn,            
    EcsOut,           
} ecs_inout_kind_t;


typedef enum ecs_oper_kind_t {
    EcsAnd,           
    EcsOr,            
    EcsNot,           
    EcsOptional,      
    EcsAndFrom,       
    EcsOrFrom,        
    EcsNotFrom,       
} ecs_oper_kind_t;


typedef enum ecs_query_cache_kind_t {
    EcsQueryCacheDefault,   
    EcsQueryCacheAuto,      

    EcsQueryCacheAll,       

    EcsQueryCacheNone,      
} ecs_query_cache_kind_t;
































































typedef struct ecs_term_ref_t {
    ecs_entity_t id;            





    const char *name;           




} ecs_term_ref_t;


struct ecs_term_t {
    ecs_id_t id;                




    ecs_term_ref_t src;          
    ecs_term_ref_t first;        
    ecs_term_ref_t second;       

    ecs_entity_t trav;          



    int16_t inout;              
    int16_t oper;               

    int8_t field_index;         
    ecs_flags16_t flags_;       
};




struct ecs_query_t {
    ecs_header_t hdr;           

    ecs_term_t *terms;          
    int32_t *sizes;             
    ecs_id_t *ids;              

    uint64_t bloom_filter;      
    ecs_flags32_t flags;        

    int8_t var_count;           

    int8_t term_count;          
    int8_t field_count;         

    
    ecs_flags32_t fixed_fields; 
    ecs_flags32_t var_fields;   
    ecs_flags32_t static_id_fields; 
    ecs_flags32_t data_fields;  
    ecs_flags32_t write_fields; 
    ecs_flags32_t read_fields;  
    ecs_flags32_t row_fields;   
    ecs_flags32_t shared_readonly_fields; 
    ecs_flags32_t set_fields;   

    ecs_query_cache_kind_t cache_kind;  


    char **vars;                


    void *ctx;                  
    void *binding_ctx;          

    ecs_entity_t entity;        
    ecs_world_t *real_world;    
    ecs_world_t *world;         

    int32_t eval_count;         
};




struct ecs_observer_t {
    ecs_header_t hdr;           

    ecs_query_t *query;         

    
    ecs_entity_t events[8];
    int32_t event_count;        

    ecs_iter_action_t callback; 
    ecs_run_action_t run;       

    void *ctx;                  
    void *callback_ctx;         
    void *run_ctx;              

    ecs_ctx_free_t ctx_free;    
    ecs_ctx_free_t callback_ctx_free; 
    ecs_ctx_free_t run_ctx_free; 

    ecs_observable_t *observable; 

    ecs_world_t *world;         
    ecs_entity_t entity;        
};
















































struct ecs_type_hooks_t {
    ecs_xtor_t ctor;            
    ecs_xtor_t dtor;            
    ecs_copy_t copy;            
    ecs_move_t move;            

    
    ecs_copy_t copy_ctor;

    
    ecs_move_t move_ctor;

    



    ecs_move_t ctor_move_dtor;

    



    ecs_move_t move_dtor;

    
    ecs_cmp_t cmp;

    
    ecs_equals_t equals;

    



    ecs_flags32_t flags;
    
    

    ecs_iter_action_t on_add;

    


    ecs_iter_action_t on_set;

    


    ecs_iter_action_t on_remove;

    



    ecs_iter_action_t on_replace;

    


    ecs_on_validate_t on_validate;

    void *ctx;                         
    void *binding_ctx;                 
    void *lifecycle_ctx;               

    ecs_ctx_free_t ctx_free;           
    ecs_ctx_free_t binding_ctx_free;   
    ecs_ctx_free_t lifecycle_ctx_free; 
};





struct ecs_type_info_t {
    ecs_size_t size;         
    ecs_size_t alignment;    
    ecs_type_hooks_t hooks;  
    ecs_entity_t component;  
    const char *name;        
    int32_t refcount;        
};













typedef struct ecs_data_t ecs_data_t;


typedef struct ecs_query_cache_match_t ecs_query_cache_match_t;


typedef struct ecs_query_cache_group_t ecs_query_cache_group_t;






typedef struct ecs_event_record_t {
    struct ecs_event_id_record_t *any;
    struct ecs_event_id_record_t *wildcard;
    struct ecs_event_id_record_t *wildcard_pair;
    ecs_map_t event_ids; 
    uint64_t event_ids_filter;
    ecs_entity_t event;
} ecs_event_record_t;

struct ecs_observable_t {
    ecs_event_record_t on_add;
    ecs_event_record_t on_remove;
    ecs_event_record_t on_set;
    ecs_event_record_t on_wildcard;
    ecs_event_record_t on_table_create;
    ecs_event_record_t on_table_delete;
    ecs_sparse_t events;  
    ecs_vec_t global_observers; 
    uint64_t last_observer_id;
};


typedef struct ecs_table_range_t {
    ecs_table_t *table;
    int32_t offset;       
    int32_t count;       
} ecs_table_range_t;




typedef struct ecs_var_t {
    ecs_table_range_t range; 
    ecs_entity_t entity;     

    



} ecs_var_t;




struct ecs_ref_t {
    ecs_entity_t entity;         
    uint64_t table_id;           
    uint32_t table_version_fast; 
    uint16_t table_version;      
    void *ptr;                   

    ecs_entity_t id;             

};


typedef struct ecs_page_iter_t {
    int32_t offset;
    int32_t limit;
    int32_t remaining;
} ecs_page_iter_t;


typedef struct ecs_worker_iter_t {
    int32_t index;
    int32_t count;
} ecs_worker_iter_t;


typedef struct ecs_table_cache_elem_t {
    ecs_table_t *table;                            
    ecs_table_record_t *tr;                        
    int16_t column;                                
    int16_t index;                                 
} ecs_table_cache_elem_t;


typedef struct ecs_table_cache_iter_t {
    const ecs_table_cache_elem_t *elems;           
    int32_t remaining;                             
    const ecs_table_cache_elem_t *cur;             
    ecs_flags32_t flags;                           
} ecs_table_cache_iter_t;


typedef struct ecs_each_iter_t {
    ecs_table_cache_iter_t it;

    
    ecs_id_t ids;
    ecs_entity_t sources;
    ecs_size_t sizes;
    int16_t columns;
    const ecs_table_record_t* trs;
} ecs_each_iter_t;

typedef struct ecs_query_op_profile_t {
    int32_t count[2]; 
} ecs_query_op_profile_t;


typedef struct ecs_query_trivial_ctx_t {
    ecs_table_cache_iter_t it;
    const ecs_table_record_t *tr;
    int32_t start_from;
    int32_t first_to_eval;
} ecs_query_trivial_ctx_t;


typedef struct ecs_query_iter_t {

    struct ecs_var_t *vars;                   
    const struct ecs_query_var_t *query_vars; 
    const struct ecs_query_op_t *ops;         
    struct ecs_query_op_ctx_t *op_ctx;        
    uint64_t *written;
    ecs_query_op_profile_t *profile;
    int16_t op;                               






    
    ecs_query_cache_group_t *group;           
    ecs_vec_t *tables;                        
    ecs_vec_t *all_tables;                    
    ecs_query_cache_match_t *elem;            
    int32_t cur, all_cur;                     
    _Bool iter_single_group;

    ecs_query_trivial_ctx_t trivial;           
} ecs_query_iter_t;



typedef struct ecs_iter_private_t {
    union {
        ecs_query_iter_t query;
        ecs_page_iter_t page;
        ecs_worker_iter_t worker;
        ecs_each_iter_t each;
    } iter;                       

    void *entity_iter;            
    ecs_stack_cursor_t *stack_cursor; 
} ecs_iter_private_t;


typedef struct ecs_commands_t {
    ecs_vec_t queue;
    ecs_stack_t stack;          
    ecs_sparse_t entries;       
} ecs_commands_t;






























__declspec(dllimport)
char* flecs_module_path_from_c(
    const char *c_name);







__declspec(dllimport)
void flecs_default_ctor(
    void *ptr, 
    int32_t count, 
    const ecs_type_info_t *type_info);


__declspec(dllimport)
_Bool flecs_type_info_ctor(
    void *ptr,
    int32_t count,
    const ecs_type_info_t *type_info);

__declspec(dllimport)
_Bool flecs_type_info_dtor(
    void *ptr,
    int32_t count,
    const ecs_type_info_t *type_info);

__declspec(dllimport)
void flecs_type_info_copy(
    void *dst,
    const void *src,
    int32_t count,
    const ecs_type_info_t *type_info);

__declspec(dllimport)
void flecs_type_info_move(
    void *dst,
    void *src,
    int32_t count,
    const ecs_type_info_t *type_info);

__declspec(dllimport)
void flecs_type_info_copy_ctor(
    void *dst,
    const void *src,
    int32_t count,
    const ecs_type_info_t *type_info);

__declspec(dllimport)
void flecs_type_info_move_ctor(
    void *dst,
    void *src,
    int32_t count,
    const ecs_type_info_t *type_info);

__declspec(dllimport)
void flecs_type_info_ctor_move_dtor(
    void *dst,
    void *src,
    int32_t count,
    const ecs_type_info_t *type_info);

__declspec(dllimport)
void flecs_type_info_move_dtor(
    void *dst,
    void *src,
    int32_t count,
    const ecs_type_info_t *type_info);

__declspec(dllimport)
int flecs_type_info_cmp(
    const void *a,
    const void *b,
    const ecs_type_info_t *type_info);

__declspec(dllimport)
_Bool flecs_type_info_equals(
    const void *a,
    const void *b,
    const ecs_type_info_t *type_info);







__declspec(dllimport)
char* flecs_vasprintf(
    const char *fmt,
    va_list args);






__declspec(dllimport)
char* flecs_asprintf(
    const char *fmt,
    ...);














__declspec(dllimport)
char* flecs_chresc(
    char *out,
    char in,
    char delimiter);








const char* flecs_chrparse(
    const char *in,
    char *out);













__declspec(dllimport)
ecs_size_t flecs_stresc(
    char *out,
    ecs_size_t size,
    char delimiter,
    const char *in);









__declspec(dllimport)
char* flecs_astresc(
    char delimiter,
    const char *in);







__declspec(dllimport)
const char* flecs_parse_ws_eol(
    const char *ptr);










__declspec(dllimport)
const char* flecs_parse_digit(
    const char *ptr,
    char *token,
    int32_t token_size);




__declspec(dllimport)
char* flecs_to_snake_case(
    const char *str);















typedef struct ecs_suspend_readonly_state_t {
    _Bool is_readonly;
    _Bool is_deferred;
    _Bool cmd_flushing;
    int32_t defer_count;
    ecs_entity_t scope;
    ecs_commands_t cmd_stack[2];
    ecs_commands_t *cmd;
    ecs_stage_t *stage;
} ecs_suspend_readonly_state_t;

__declspec(dllimport)
ecs_world_t* flecs_suspend_readonly(
    const ecs_world_t *world,
    ecs_suspend_readonly_state_t *state);

__declspec(dllimport)
void flecs_resume_readonly(
    ecs_world_t *world,
    ecs_suspend_readonly_state_t *state);







__declspec(dllimport)
int32_t flecs_table_observed_count(
    const ecs_table_t *table);





__declspec(dllimport)
void flecs_dump_backtrace(
    void *stream);






__declspec(dllimport)
int32_t flecs_poly_claim_(
    ecs_poly_t *poly);






__declspec(dllimport)
int32_t flecs_poly_release_(
    ecs_poly_t *poly);












__declspec(dllimport)
int32_t flecs_poly_refcount(
    ecs_poly_t *poly);









__declspec(dllimport)
int32_t flecs_component_ids_index_get(void);







__declspec(dllimport)
ecs_entity_t flecs_component_ids_get(
    const ecs_world_t *world, 
    int32_t index);









__declspec(dllimport)
ecs_entity_t flecs_component_ids_get_alive(
    const ecs_world_t *world, 
    int32_t index);







__declspec(dllimport)
void flecs_component_ids_set(
    ecs_world_t *world, 
    int32_t index,
    ecs_entity_t id);










__declspec(dllimport)

_Bool flecs_query_trivial_cached_next(
    ecs_iter_t *it);

















__declspec(dllimport)
void flecs_check_exclusive_world_access_write(
    const ecs_world_t *world);





__declspec(dllimport)
void flecs_check_exclusive_world_access_read(
    const ecs_world_t *world);







__declspec(dllimport)
_Bool flecs_defer_end(
    ecs_world_t *world,
    ecs_stage_t *stage);

























































typedef struct {
    ecs_vec_t keys; 
    ecs_vec_t values; 
} ecs_hm_bucket_t;


typedef struct {
    ecs_hash_value_action_t hash; 
    ecs_compare_action_t compare; 
    ecs_size_t key_size; 
    ecs_size_t value_size; 
    ecs_map_t impl; 
} ecs_hashmap_t;


typedef struct {
    ecs_map_iter_t it; 
    ecs_hm_bucket_t *bucket; 
    int32_t index; 
} flecs_hashmap_iter_t;


typedef struct {
    void *key; 
    void *value; 
    uint64_t hash; 
} flecs_hashmap_result_t;










__declspec(dllimport)
void flecs_hashmap_init_(
    ecs_hashmap_t *hm,
    ecs_size_t key_size,
    ecs_size_t value_size,
    ecs_hash_value_action_t hash,
    ecs_compare_action_t compare,
    ecs_allocator_t *allocator);









__declspec(dllimport)
void flecs_hashmap_fini(
    ecs_hashmap_t *map);









__declspec(dllimport)
void* flecs_hashmap_get_(
    const ecs_hashmap_t *map,
    ecs_size_t key_size,
    const void *key,
    ecs_size_t value_size);













__declspec(dllimport)
flecs_hashmap_result_t flecs_hashmap_ensure_(
    ecs_hashmap_t *map,
    ecs_size_t key_size,
    const void *key,
    ecs_size_t value_size);













__declspec(dllimport)
void flecs_hashmap_remove_w_hash_(
    ecs_hashmap_t *map,
    ecs_size_t key_size,
    const void *key,
    ecs_size_t value_size,
    uint64_t hash);











__declspec(dllimport)
ecs_hm_bucket_t* flecs_hashmap_get_bucket(
    const ecs_hashmap_t *map,
    uint64_t hash);








__declspec(dllimport)
void flecs_hm_bucket_remove(
    ecs_hashmap_t *map,
    ecs_hm_bucket_t *bucket,
    uint64_t hash,
    int32_t index);






__declspec(dllimport)
void flecs_hashmap_copy(
    ecs_hashmap_t *dst,
    const ecs_hashmap_t *src);






__declspec(dllimport)
flecs_hashmap_iter_t flecs_hashmap_iter(
    ecs_hashmap_t *map);









__declspec(dllimport)
void* flecs_hashmap_next_(
    flecs_hashmap_iter_t *it,
    ecs_size_t key_size,
    void *key_out,
    ecs_size_t value_size);























struct ecs_record_t {
    ecs_table_t *table;                        
    uint32_t row;                              
    int32_t dense;                             
};


typedef struct ecs_table_cache_hdr_t {
    struct ecs_component_record_t *cr;         
    ecs_table_t *table;                        
} ecs_table_cache_hdr_t;




struct ecs_table_record_t {
    ecs_table_cache_hdr_t hdr;                 
    int16_t index;                             
    int16_t count;                             
    int16_t column;                            
};



typedef struct ecs_table_diff_t {
    ecs_type_t added;                
    ecs_type_t removed;              
    ecs_flags32_t added_flags;
    ecs_flags32_t removed_flags;
} ecs_table_diff_t;


typedef struct ecs_parent_record_t {
    uint32_t entity;                
    int32_t count;                  
} ecs_parent_record_t;













__declspec(dllimport)
ecs_record_t* ecs_record_find(
    const ecs_world_t *world,
    ecs_entity_t entity);







__declspec(dllimport)
ecs_entity_t ecs_record_get_entity(
    const ecs_record_t *record);









__declspec(dllimport)
void flecs_add_ids(
    ecs_world_t *world,
    ecs_entity_t entity,
    const ecs_id_t *ids,
    int32_t count);















__declspec(dllimport)
const void* ecs_record_get_id(
    const ecs_world_t *world,
    const ecs_record_t *record,
    ecs_id_t id);








__declspec(dllimport)
void* ecs_record_ensure_id(
    ecs_world_t *world,
    ecs_record_t *record,
    ecs_id_t id);








__declspec(dllimport)
_Bool ecs_record_has_id(
    ecs_world_t *world,
    const ecs_record_t *record,
    ecs_id_t id);

















__declspec(dllimport)
void* ecs_record_get_by_column(
    const ecs_record_t *record,
    int32_t column,
    size_t size);







__declspec(dllimport)
 ecs_component_record_t* flecs_components_get(
    const ecs_world_t *world,
    ecs_id_t id);







__declspec(dllimport)
 ecs_component_record_t* flecs_components_ensure(
    ecs_world_t *world,
    ecs_id_t id);






__declspec(dllimport)
ecs_id_t flecs_component_get_id(
    const ecs_component_record_t *cr);







__declspec(dllimport)
ecs_flags32_t flecs_component_get_flags(
    const ecs_world_t *world,
    ecs_id_t id);






__declspec(dllimport)
const ecs_type_info_t* flecs_component_get_type_info(
    const ecs_component_record_t *cr);




__declspec(dllimport)
ecs_sparse_t* flecs_component_get_sparse(
    const ecs_component_record_t *cr);













__declspec(dllimport)
ecs_component_record_t* flecs_component_dont_fragment_first(
    const ecs_world_t *world);







__declspec(dllimport)
ecs_component_record_t* flecs_component_dont_fragment_next(
    const ecs_component_record_t *cr);









__declspec(dllimport)
 const ecs_table_record_t* flecs_component_get_table(
    const ecs_component_record_t *cr,
    const ecs_table_t *table);



















__declspec(dllimport)
 ecs_parent_record_t* flecs_component_get_parent_record(
    const ecs_component_record_t *cr,
    const ecs_table_t *table);









__declspec(dllimport)
 int32_t flecs_component_get_childof_depth(
    const ecs_component_record_t *cr);






















__declspec(dllimport)
_Bool flecs_component_iter(
    const ecs_component_record_t *cr,
    ecs_table_cache_iter_t *iter_out);







__declspec(dllimport)
const ecs_table_record_t* flecs_component_next(
    ecs_table_cache_iter_t *iter);


typedef struct ecs_table_records_t {
    const ecs_table_record_t *array;
    int32_t count;
} ecs_table_records_t;







__declspec(dllimport)
ecs_table_records_t flecs_table_records(
    ecs_table_t* table);






__declspec(dllimport)
ecs_component_record_t* flecs_table_record_get_component(
    const ecs_table_record_t *tr);




__declspec(dllimport)
ecs_sparse_t* flecs_field_sparse(
    const ecs_iter_t *it,
    int8_t index);







__declspec(dllimport)
uint64_t flecs_table_id(
    ecs_table_t* table);



__declspec(dllimport)
ecs_flags32_t flecs_table_flags(
    const ecs_table_t* table);











__declspec(dllimport)
 ecs_table_t *flecs_table_traverse_add(
    ecs_world_t *world,
    ecs_table_t *table,
    ecs_id_t *id_ptr,
    ecs_table_diff_t *diff);









typedef struct ecs_value_t {
    ecs_entity_t type;      
    void *ptr;              
} ecs_value_t;





typedef struct ecs_entity_desc_t {
    int32_t _canary;      

    ecs_entity_t id;      

    ecs_entity_t parent;  

    const char *name;     




    const char *sep;      



    const char *root_sep; 

    const char *symbol;   









    _Bool use_low_id;      


} ecs_entity_desc_t;





typedef struct ecs_bulk_desc_t {
    int32_t _canary;        

    ecs_entity_t *entities; 




    int32_t count;     

    ecs_id_t ids[32]; 

    void **data;       






    ecs_table_t *table; 




} ecs_bulk_desc_t;





typedef struct ecs_component_desc_t {
    int32_t _canary;        

    
    ecs_entity_t entity;

    
    ecs_type_info_t type;
} ecs_component_desc_t;







































struct ecs_iter_t {
    
    ecs_world_t *world;           
    ecs_world_t *real_world;      

    
    int32_t offset;               
    int32_t count;                
    const ecs_entity_t *entities; 
    void **ptrs;                  
    const ecs_table_record_t **trs; 
    const int16_t *columns;
    const ecs_size_t *sizes;      
    ecs_table_t *table;           
    ecs_table_t *other_table;     
    ecs_id_t *ids;                
    ecs_entity_t *sources;        

    ecs_flags64_t constrained_vars; 

    ecs_flags32_t set_fields;     
    ecs_flags32_t ref_fields;     
    ecs_flags32_t row_fields;     
    ecs_flags32_t up_fields;      

    
    ecs_entity_t system;          
    ecs_entity_t event;           
    ecs_id_t event_id;            
    int32_t event_cur;            

    
    int8_t field_count;           
    int8_t term_index;            


    const ecs_query_t *query;     

    
    void *param;                  
    void *ctx;                    
    void *binding_ctx;            
    void *callback_ctx;           
    void *run_ctx;                

    
    float delta_time;       
    float delta_system_time;

    
    int32_t frame_offset;         

    
    ecs_flags32_t flags;          
    ecs_entity_t interrupted_by;  
    ecs_iter_private_t priv_;     

    
    ecs_iter_next_action_t next;  
    ecs_iter_action_t callback;   
    ecs_iter_fini_action_t fini;  
    ecs_iter_t *chain_it;         
};




































































typedef struct ecs_query_desc_t {
    
    int32_t _canary;

    
    ecs_term_t terms[32];

    
    const char *expr;

    
    ecs_query_cache_kind_t cache_kind;

    
    ecs_flags32_t flags;

    


    ecs_order_by_action_t order_by_callback;

    

    ecs_sort_table_action_t order_by_table_callback;

    

    ecs_entity_t order_by;

    

    ecs_id_t group_by;

    




    ecs_group_by_action_t group_by_callback;

    

    ecs_group_create_action_t on_group_create;

    

    ecs_group_delete_action_t on_group_delete;

    
    void *group_by_ctx;

    
    ecs_ctx_free_t group_by_ctx_free;

    
    void *ctx;

    
    void *binding_ctx;

    
    ecs_ctx_free_t ctx_free;

    
    ecs_ctx_free_t binding_ctx_free;

    
    ecs_entity_t entity;
} ecs_query_desc_t;





typedef struct ecs_observer_desc_t {
    
    int32_t _canary;

    
    ecs_entity_t entity;

    
    ecs_query_desc_t query;

    
    ecs_entity_t events[8];

    

    _Bool yield_existing;

    


    _Bool global_observer;

    
    ecs_iter_action_t callback;

    





    ecs_run_action_t run;

    
    void *ctx;

    
    ecs_ctx_free_t ctx_free;

    
    void *callback_ctx;

    
    ecs_ctx_free_t callback_ctx_free;

    
    void *run_ctx;

    
    ecs_ctx_free_t run_ctx_free;

    
    int32_t *last_event_id;
    int8_t term_index_;    
    ecs_flags32_t flags_;  
} ecs_observer_desc_t;





typedef struct ecs_event_desc_t {
    
    ecs_entity_t event;

    


    const ecs_type_t *ids;

    
    ecs_table_t *table;

    

    ecs_table_t *other_table;

    
    int32_t offset;

    


    int32_t count;

    
    ecs_entity_t entity;

    



    void *param;

    


    const void *const_param;

    



    void *set_ptr;

    
    ecs_poly_t *observable;

    
    ecs_flags32_t flags;
} ecs_event_desc_t;









typedef struct ecs_build_info_t {
    const char *compiler;           
    const char **addons;            
    const char **flags;             
    const char *version;            
    int16_t version_major;          
    int16_t version_minor;          
    int16_t version_patch;          
    _Bool debug;                     
    _Bool sanitize;                  
    _Bool perf_trace;                
} ecs_build_info_t;


typedef struct ecs_world_info_t {
    ecs_entity_t last_component_id;   

    float delta_time_raw;       
    float delta_time;           
    float time_scale;           
    float target_fps;           
    float frame_time_total;     
    float system_time_total;    
    float emit_time_total;      
    float merge_time_total;     
    float rematch_time_total;   
    double world_time_total;          
    double world_time_total_raw;      

    int64_t frame_count_total;        
    int64_t merge_count_total;        
    int64_t eval_comp_monitors_total; 
    int64_t rematch_count_total;      

    int64_t id_create_total;          
    int64_t id_delete_total;          
    int64_t table_create_total;       
    int64_t table_delete_total;       
    int64_t pipeline_build_count_total; 
    int64_t systems_ran_total;        
    int64_t observers_ran_total;      
    int64_t queries_ran_total;        

    int32_t tag_id_count;             
    int32_t component_id_count;       
    int32_t pair_id_count;            

    int32_t table_count;              

    uint32_t creation_time;           

    
    struct {
        int64_t add_count;             
        int64_t remove_count;          
        int64_t delete_count;          
        int64_t clear_count;           
        int64_t set_count;             
        int64_t ensure_count;          
        int64_t modified_count;        
        int64_t discard_count;         
        int64_t event_count;           
        int64_t other_count;           
        int64_t batched_entity_count;  
        int64_t batched_command_count; 
    } cmd;                             

    const char *name_prefix;          



} ecs_world_info_t;


typedef struct ecs_query_group_info_t {
    uint64_t id;          
    int32_t match_count;  
    int32_t table_count;  
    void *ctx;            
} ecs_query_group_info_t;











typedef struct EcsIdentifier {
    char *value;          
    ecs_size_t length;    
    uint64_t hash;        
    uint64_t index_hash;  
    ecs_hashmap_t *index; 
} EcsIdentifier;


typedef struct EcsComponent {
    ecs_size_t size;           
    ecs_size_t alignment;      
} EcsComponent;


typedef struct EcsPoly {
    ecs_poly_t *poly;          
} EcsPoly;


typedef struct EcsParent {
    ecs_entity_t value;     
} EcsParent;


typedef struct {
    const char *child_name; 
    ecs_table_t *table;     
    uint32_t child;         
    int32_t parent_index;   
} ecs_tree_spawner_child_t;


typedef struct {
    ecs_vec_t children;     
} ecs_tree_spawner_t;








typedef struct EcsTreeSpawner {
    ecs_tree_spawner_t data[(6)]; 
} EcsTreeSpawner;









































__declspec(dllimport) extern const ecs_id_t ECS_PAIR;


__declspec(dllimport) extern const ecs_id_t ECS_AUTO_OVERRIDE;


__declspec(dllimport) extern const ecs_id_t ECS_TOGGLE;


__declspec(dllimport) extern const ecs_id_t ECS_VALUE_PAIR;











__declspec(dllimport) extern const ecs_entity_t FLECS_IDEcsComponentID_;


__declspec(dllimport) extern const ecs_entity_t FLECS_IDEcsIdentifierID_;


__declspec(dllimport) extern const ecs_entity_t FLECS_IDEcsPolyID_;


__declspec(dllimport) extern const ecs_entity_t FLECS_IDEcsParentID_;


__declspec(dllimport) extern const ecs_entity_t FLECS_IDEcsTreeSpawnerID_;


__declspec(dllimport) extern const ecs_entity_t EcsParentDepth;


__declspec(dllimport) extern const ecs_entity_t EcsQuery;


__declspec(dllimport) extern const ecs_entity_t EcsObserver;


__declspec(dllimport) extern const ecs_entity_t EcsSystem;


__declspec(dllimport) extern const ecs_entity_t FLECS_IDEcsTickSourceID_;


__declspec(dllimport) extern const ecs_entity_t FLECS_IDEcsPipelineQueryID_;


__declspec(dllimport) extern const ecs_entity_t FLECS_IDEcsTimerID_;


__declspec(dllimport) extern const ecs_entity_t FLECS_IDEcsRateFilterID_;


__declspec(dllimport) extern const ecs_entity_t EcsFlecs;


__declspec(dllimport) extern const ecs_entity_t EcsFlecsCore;


__declspec(dllimport) extern const ecs_entity_t EcsWorld;


__declspec(dllimport) extern const ecs_entity_t EcsWildcard;


__declspec(dllimport) extern const ecs_entity_t EcsAny;


__declspec(dllimport) extern const ecs_entity_t EcsThis;


__declspec(dllimport) extern const ecs_entity_t EcsVariable;








__declspec(dllimport) extern const ecs_entity_t EcsTransitive;








__declspec(dllimport) extern const ecs_entity_t EcsReflexive;






__declspec(dllimport) extern const ecs_entity_t EcsInheritable;


__declspec(dllimport) extern const ecs_entity_t EcsOnInstantiate;





__declspec(dllimport) extern const ecs_entity_t EcsOverride;




__declspec(dllimport) extern const ecs_entity_t EcsInherit;






__declspec(dllimport) extern const ecs_entity_t EcsDontInherit;










__declspec(dllimport) extern const ecs_entity_t EcsExclusive;



__declspec(dllimport) extern const ecs_entity_t EcsTraversable;










__declspec(dllimport) extern const ecs_entity_t EcsWith;


__declspec(dllimport) extern const ecs_entity_t EcsCanToggle;



__declspec(dllimport) extern const ecs_entity_t EcsPairIsTag;


__declspec(dllimport) extern const ecs_entity_t EcsName;


__declspec(dllimport) extern const ecs_entity_t EcsSymbol;


__declspec(dllimport) extern const ecs_entity_t EcsAlias;


__declspec(dllimport) extern const ecs_entity_t EcsChildOf;


__declspec(dllimport) extern const ecs_entity_t EcsIsA;


__declspec(dllimport) extern const ecs_entity_t EcsDependsOn;


__declspec(dllimport) extern const ecs_entity_t EcsOrderedChildren;


__declspec(dllimport) extern const ecs_entity_t EcsModule;




__declspec(dllimport) extern const ecs_entity_t EcsPrefab;




__declspec(dllimport) extern const ecs_entity_t EcsDisabled;




__declspec(dllimport) extern const ecs_entity_t EcsNotQueryable;


__declspec(dllimport) extern const ecs_entity_t EcsOnAdd;


__declspec(dllimport) extern const ecs_entity_t EcsOnRemove;


__declspec(dllimport) extern const ecs_entity_t EcsOnSet;


__declspec(dllimport) extern const ecs_entity_t EcsMonitor;


__declspec(dllimport) extern const ecs_entity_t EcsOnTableCreate;


__declspec(dllimport) extern const ecs_entity_t EcsOnTableDelete;


__declspec(dllimport) extern const ecs_entity_t EcsOnDelete;



__declspec(dllimport) extern const ecs_entity_t EcsOnDeleteTarget;



__declspec(dllimport) extern const ecs_entity_t EcsRemove;



__declspec(dllimport) extern const ecs_entity_t EcsDelete;



__declspec(dllimport) extern const ecs_entity_t EcsPanic;


__declspec(dllimport) extern const ecs_entity_t EcsSparse;


__declspec(dllimport) extern const ecs_entity_t EcsDontFragment;


__declspec(dllimport) extern const ecs_entity_t EcsPredEq;


__declspec(dllimport) extern const ecs_entity_t EcsPredMatch;


__declspec(dllimport) extern const ecs_entity_t EcsPredLookup;


__declspec(dllimport) extern const ecs_entity_t EcsScopeOpen;


__declspec(dllimport) extern const ecs_entity_t EcsScopeClose;





__declspec(dllimport) extern const ecs_entity_t EcsEmpty;

__declspec(dllimport) extern const ecs_entity_t FLECS_IDEcsPipelineID_; 
__declspec(dllimport) extern const ecs_entity_t EcsOnStart;     
__declspec(dllimport) extern const ecs_entity_t EcsPreFrame;    
__declspec(dllimport) extern const ecs_entity_t EcsOnLoad;      
__declspec(dllimport) extern const ecs_entity_t EcsPostLoad;    
__declspec(dllimport) extern const ecs_entity_t EcsPreUpdate;   
__declspec(dllimport) extern const ecs_entity_t EcsOnUpdate;    
__declspec(dllimport) extern const ecs_entity_t EcsOnValidate;  
__declspec(dllimport) extern const ecs_entity_t EcsPostUpdate;  
__declspec(dllimport) extern const ecs_entity_t EcsPreStore;    
__declspec(dllimport) extern const ecs_entity_t EcsOnStore;     
__declspec(dllimport) extern const ecs_entity_t EcsPostFrame;   
__declspec(dllimport) extern const ecs_entity_t EcsPhase;       

__declspec(dllimport) extern const ecs_entity_t EcsConstant;    








































__declspec(dllimport)
ecs_world_t* ecs_init(void);







__declspec(dllimport)
ecs_world_t* ecs_mini(void);










__declspec(dllimport)
ecs_world_t* ecs_init_w_args(
    int argc,
    char *argv[]);







__declspec(dllimport)
int ecs_fini(
    ecs_world_t *world);








__declspec(dllimport)
_Bool ecs_is_fini(
    const ecs_world_t *world);









__declspec(dllimport)
void ecs_atfini(
    ecs_world_t *world,
    ecs_fini_action_t action,
    void *ctx);


typedef struct ecs_entities_t {
    const ecs_entity_t *ids; 
    int32_t count;           
    int32_t alive_count;     
} ecs_entities_t;



























__declspec(dllimport)
ecs_entities_t ecs_get_entities(
    const ecs_world_t *world);








__declspec(dllimport)
ecs_flags32_t ecs_world_get_flags(
    const ecs_world_t *world);













































































__declspec(dllimport)
_Bool ecs_readonly_begin(
    ecs_world_t *world,
    _Bool multi_threaded);








__declspec(dllimport)
void ecs_readonly_end(
    ecs_world_t *world);






__declspec(dllimport)
void ecs_merge(
    ecs_world_t *stage);

















__declspec(dllimport)
_Bool ecs_defer_begin(
    ecs_world_t *world);














__declspec(dllimport)
_Bool ecs_defer_end(
    ecs_world_t *world);















__declspec(dllimport)
void ecs_defer_suspend(
    ecs_world_t *world);











__declspec(dllimport)
void ecs_defer_resume(
    ecs_world_t *world);












__declspec(dllimport)
_Bool ecs_is_deferred(
    const ecs_world_t *world);












__declspec(dllimport)
_Bool ecs_is_defer_suspended(
    const ecs_world_t *world);














__declspec(dllimport)
void ecs_set_stage_count(
    ecs_world_t *world,
    int32_t stages);







__declspec(dllimport)
int32_t ecs_get_stage_count(
    const ecs_world_t *world);
















__declspec(dllimport)
ecs_world_t* ecs_get_stage(
    const ecs_world_t *world,
    int32_t stage_id);








__declspec(dllimport)
_Bool ecs_stage_is_readonly(
    const ecs_world_t *world);








__declspec(dllimport)
ecs_world_t* ecs_stage_new(
    ecs_world_t *world);





__declspec(dllimport)
void ecs_stage_free(
    ecs_world_t *stage);








__declspec(dllimport)
int32_t ecs_stage_get_id(
    const ecs_world_t *world);
















__declspec(dllimport)
void ecs_set_ctx(
    ecs_world_t *world,
    void *ctx,
    ecs_ctx_free_t ctx_free);









__declspec(dllimport)
void ecs_set_binding_ctx(
    ecs_world_t *world,
    void *ctx,
    ecs_ctx_free_t ctx_free);








__declspec(dllimport)
void* ecs_get_ctx(
    const ecs_world_t *world);








__declspec(dllimport)
void* ecs_get_binding_ctx(
    const ecs_world_t *world);






__declspec(dllimport)
const ecs_build_info_t* ecs_get_build_info(void);






__declspec(dllimport)
const ecs_world_info_t* ecs_get_world_info(
    const ecs_world_t *world);









__declspec(dllimport)
void ecs_dim(
    ecs_world_t *world,
    int32_t entity_count);















__declspec(dllimport)
void ecs_shrink(
    ecs_world_t *world);






__declspec(dllimport)
ecs_entity_t ecs_get_max_id(
    const ecs_world_t *world);














__declspec(dllimport)
void ecs_run_aperiodic(
    ecs_world_t *world,
    ecs_flags32_t flags);


typedef struct ecs_delete_empty_tables_desc_t {
    
    uint16_t clear_generation;

    
    uint16_t delete_generation;

    
    double time_budget_seconds;

    

    int32_t offset;
} ecs_delete_empty_tables_desc_t;




































__declspec(dllimport)
int32_t ecs_delete_empty_tables(
    ecs_world_t *world,
    const ecs_delete_empty_tables_desc_t *desc);






__declspec(dllimport)
const ecs_world_t* ecs_get_world(
    const ecs_poly_t *poly);






__declspec(dllimport)
ecs_entity_t ecs_get_entity(
    const ecs_poly_t *poly);














__declspec(dllimport)
_Bool flecs_poly_is_(
    const ecs_poly_t *object,
    int32_t type);















__declspec(dllimport)
ecs_id_t ecs_make_pair(
    ecs_entity_t first,
    ecs_entity_t second);























__declspec(dllimport)
void ecs_exclusive_access_begin(
    ecs_world_t *world,
    const char *thread_name);























__declspec(dllimport)
void ecs_exclusive_access_end(
    ecs_world_t *world,
    _Bool lock_world);


























__declspec(dllimport)
ecs_entity_t ecs_new(
    ecs_world_t *world);


















__declspec(dllimport)
ecs_entity_t ecs_new_low_id(
    ecs_world_t *world);








__declspec(dllimport)
ecs_entity_t ecs_new_w_id(
    ecs_world_t *world,
    ecs_id_t component);








__declspec(dllimport)
ecs_entity_t ecs_new_w_table(
    ecs_world_t *world,
    ecs_table_t *table);



















__declspec(dllimport)
ecs_entity_t ecs_entity_init(
    ecs_world_t *world,
    const ecs_entity_desc_t *desc);











__declspec(dllimport)
ecs_entity_t ecs_insert_w_values(
    ecs_world_t *world,
    const ecs_value_t *values);



























__declspec(dllimport)
const ecs_entity_t* ecs_bulk_init(
    ecs_world_t *world,
    const ecs_bulk_desc_t *desc);










__declspec(dllimport)
const ecs_entity_t* ecs_bulk_new_w_id(
    ecs_world_t *world,
    ecs_id_t component,
    int32_t count);
















__declspec(dllimport)
ecs_entity_t ecs_clone(
    ecs_world_t *world,
    ecs_entity_t dst,
    ecs_entity_t src,
    _Bool copy_value);









__declspec(dllimport)
void ecs_delete(
    ecs_world_t *world,
    ecs_entity_t entity);








__declspec(dllimport)
void ecs_delete_with(
    ecs_world_t *world,
    ecs_id_t component);


















__declspec(dllimport)
void ecs_set_child_order(
    ecs_world_t *world,
    ecs_entity_t parent,
    const ecs_entity_t *children,
    int32_t child_count);










__declspec(dllimport)
ecs_entities_t ecs_get_ordered_children(
    const ecs_world_t *world,
    ecs_entity_t parent);


















__declspec(dllimport)
void ecs_add_id(
    ecs_world_t *world,
    ecs_entity_t entity,
    ecs_id_t component);









__declspec(dllimport)
void ecs_remove_id(
    ecs_world_t *world,
    ecs_entity_t entity,
    ecs_id_t component);




















































__declspec(dllimport)
void ecs_auto_override_id(
    ecs_world_t *world,
    ecs_entity_t entity,
    ecs_id_t component);







__declspec(dllimport)
void ecs_clear(
    ecs_world_t *world,
    ecs_entity_t entity);








__declspec(dllimport)
void ecs_remove_all(
    ecs_world_t *world,
    ecs_id_t component);



















__declspec(dllimport)
void ecs_enable(
    ecs_world_t *world,
    ecs_entity_t entity,
    _Bool enabled);














__declspec(dllimport)
void ecs_enable_id(
    ecs_world_t *world,
    ecs_entity_t entity,
    ecs_id_t component,
    _Bool enable);











__declspec(dllimport)
_Bool ecs_is_enabled_id(
    const ecs_world_t *world,
    ecs_entity_t entity,
    ecs_id_t component);
























__declspec(dllimport)
 const void* ecs_get_id(
    const ecs_world_t *world,
    ecs_entity_t entity,
    ecs_id_t component);















__declspec(dllimport)
 void* ecs_get_mut_id(
    const ecs_world_t *world,
    ecs_entity_t entity,
    ecs_id_t component);















__declspec(dllimport)
 void* ecs_get_sparse_id(
    const ecs_world_t *world,
    ecs_entity_t entity,
    ecs_id_t component,
    size_t size);


















__declspec(dllimport)
void* ecs_ensure_id(
    ecs_world_t *world,
    ecs_entity_t entity,
    ecs_id_t component,
    size_t size);











 __declspec(dllimport)
ecs_ref_t ecs_ref_init_id(
    const ecs_world_t *world,
    ecs_entity_t entity,
    ecs_id_t component);











 __declspec(dllimport)
void* ecs_ref_get_id(
    const ecs_world_t *world,
    ecs_ref_t *ref,
    ecs_id_t component);









 __declspec(dllimport)
void ecs_ref_update(
    const ecs_world_t *world,
    ecs_ref_t *ref,
    ecs_id_t component);





















__declspec(dllimport)
void* ecs_emplace_id(
    ecs_world_t *world,
    ecs_entity_t entity,
    ecs_id_t component,
    size_t size,
    _Bool *is_new);










__declspec(dllimport)
void ecs_modified_id(
    ecs_world_t *world,
    ecs_entity_t entity,
    ecs_id_t component);
















__declspec(dllimport)
void ecs_set_id(
    ecs_world_t *world,
    ecs_entity_t entity,
    ecs_id_t component,
    size_t size,
    const void *ptr);





























__declspec(dllimport)
_Bool ecs_is_valid(
    const ecs_world_t *world,
    ecs_entity_t e);






























__declspec(dllimport)
_Bool ecs_is_alive(
    const ecs_world_t *world,
    ecs_entity_t e);






__declspec(dllimport)
ecs_id_t ecs_strip_generation(
    ecs_entity_t e);

















__declspec(dllimport)
ecs_entity_t ecs_get_alive(
    const ecs_world_t *world,
    ecs_entity_t e);























__declspec(dllimport)
void ecs_make_alive(
    ecs_world_t *world,
    ecs_entity_t entity);



















__declspec(dllimport)
void ecs_make_alive_id(
    ecs_world_t *world,
    ecs_id_t component);








__declspec(dllimport)
_Bool ecs_exists(
    const ecs_world_t *world,
    ecs_entity_t entity);















__declspec(dllimport)
void ecs_set_version(
    ecs_world_t *world,
    ecs_entity_t entity);






__declspec(dllimport)
uint32_t ecs_get_version(
    ecs_entity_t entity);
















__declspec(dllimport)
const ecs_type_t* ecs_get_type(
    const ecs_world_t *world,
    ecs_entity_t entity);







__declspec(dllimport)
ecs_table_t* ecs_get_table(
    const ecs_world_t *world,
    ecs_entity_t entity);








__declspec(dllimport)
char* ecs_type_str(
    const ecs_world_t *world,
    const ecs_type_t* type);












__declspec(dllimport)
char* ecs_table_str(
    const ecs_world_t *world,
    const ecs_table_t *table);















__declspec(dllimport)
char* ecs_entity_str(
    const ecs_world_t *world,
    ecs_entity_t entity);











__declspec(dllimport)
 _Bool ecs_has_id(
    const ecs_world_t *world,
    ecs_entity_t entity,
    ecs_id_t component);











__declspec(dllimport)
 _Bool ecs_owns_id(
    const ecs_world_t *world,
    ecs_entity_t entity,
    ecs_id_t component);















__declspec(dllimport)
ecs_entity_t ecs_get_target(
    const ecs_world_t *world,
    ecs_entity_t entity,
    ecs_entity_t rel,
    int32_t index);














__declspec(dllimport)
ecs_entity_t ecs_get_parent(
    const ecs_world_t *world,
    ecs_entity_t entity);














__declspec(dllimport)
ecs_entity_t ecs_new_w_parent(
    ecs_world_t *world,
    ecs_entity_t parent,
    const char *name);





















__declspec(dllimport)
ecs_entity_t ecs_get_target_for_id(
    const ecs_world_t *world,
    ecs_entity_t entity,
    ecs_entity_t rel,
    ecs_id_t component);











__declspec(dllimport)
int32_t ecs_get_depth(
    const ecs_world_t *world,
    ecs_entity_t entity,
    ecs_entity_t rel);








__declspec(dllimport)
int32_t ecs_count_id(
    const ecs_world_t *world,
    ecs_id_t entity);



















__declspec(dllimport)
const char* ecs_get_name(
    const ecs_world_t *world,
    ecs_entity_t entity);










__declspec(dllimport)
const char* ecs_get_symbol(
    const ecs_world_t *world,
    ecs_entity_t entity);














__declspec(dllimport)
ecs_entity_t ecs_set_name(
    ecs_world_t *world,
    ecs_entity_t entity,
    const char *name);














__declspec(dllimport)
ecs_entity_t ecs_set_symbol(
    ecs_world_t *world,
    ecs_entity_t entity,
    const char *symbol);












__declspec(dllimport)
void ecs_set_alias(
    ecs_world_t *world,
    ecs_entity_t entity,
    const char *alias);
















__declspec(dllimport)
ecs_entity_t ecs_lookup(
    const ecs_world_t *world,
    const char *path);















__declspec(dllimport)
ecs_entity_t ecs_lookup_child(
    const ecs_world_t *world,
    ecs_entity_t parent,
    const char *name);























__declspec(dllimport)
ecs_entity_t ecs_lookup_path_w_sep(
    const ecs_world_t *world,
    ecs_entity_t parent,
    const char *path,
    const char *sep,
    const char *prefix,
    _Bool recursive);


















__declspec(dllimport)
ecs_entity_t ecs_lookup_symbol(
    const ecs_world_t *world,
    const char *symbol,
    _Bool lookup_as_path,
    _Bool recursive);






















__declspec(dllimport)
char* ecs_get_path_w_sep(
    const ecs_world_t *world,
    ecs_entity_t parent,
    ecs_entity_t child,
    const char *sep,
    const char *prefix);














__declspec(dllimport)
void ecs_get_path_w_sep_buf(
    const ecs_world_t *world,
    ecs_entity_t parent,
    ecs_entity_t child,
    const char *sep,
    const char *prefix,
    ecs_strbuf_t *buf,
    _Bool escape);
















__declspec(dllimport)
ecs_entity_t ecs_new_from_path_w_sep(
    ecs_world_t *world,
    ecs_entity_t parent,
    const char *path,
    const char *sep,
    const char *prefix);















__declspec(dllimport)
ecs_entity_t ecs_add_path_w_sep(
    ecs_world_t *world,
    ecs_entity_t entity,
    ecs_entity_t parent,
    const char *path,
    const char *sep,
    const char *prefix);














__declspec(dllimport)
ecs_entity_t ecs_set_scope(
    ecs_world_t *world,
    ecs_entity_t scope);








__declspec(dllimport)
ecs_entity_t ecs_get_scope(
    const ecs_world_t *world);










__declspec(dllimport)
const char* ecs_set_name_prefix(
    ecs_world_t *world,
    const char *prefix);



























__declspec(dllimport)
ecs_entity_t* ecs_set_lookup_path(
    ecs_world_t *world,
    const ecs_entity_t *lookup_path);







__declspec(dllimport)
ecs_entity_t* ecs_get_lookup_path(
    const ecs_world_t *world);

























__declspec(dllimport)
ecs_entity_t ecs_component_init(
    ecs_world_t *world,
    const ecs_component_desc_t *desc);










__declspec(dllimport)
const ecs_type_info_t* ecs_get_type_info(
    const ecs_world_t *world,
    ecs_id_t component);












__declspec(dllimport)
void ecs_set_hooks_id(
    ecs_world_t *world,
    ecs_entity_t component,
    const ecs_type_hooks_t *hooks);







__declspec(dllimport)
const ecs_type_hooks_t* ecs_get_hooks_id(
    const ecs_world_t *world,
    ecs_entity_t component);
























__declspec(dllimport)
_Bool ecs_id_is_tag(
    const ecs_world_t *world,
    ecs_id_t component);









__declspec(dllimport)
_Bool ecs_id_in_use(
    const ecs_world_t *world,
    ecs_id_t component);




















__declspec(dllimport)
ecs_entity_t ecs_get_typeid(
    const ecs_world_t *world,
    ecs_id_t component);









__declspec(dllimport)
_Bool ecs_id_match(
    ecs_id_t component,
    ecs_id_t pattern);






__declspec(dllimport)
_Bool ecs_id_is_pair(
    ecs_id_t component);






__declspec(dllimport)
_Bool ecs_id_is_wildcard(
    ecs_id_t component);






_Bool ecs_id_is_any(
    ecs_id_t component);














__declspec(dllimport)
_Bool ecs_id_is_valid(
    const ecs_world_t *world,
    ecs_id_t component);









__declspec(dllimport)
ecs_flags32_t ecs_id_get_flags(
    const ecs_world_t *world,
    ecs_id_t component);











__declspec(dllimport)
const char* ecs_id_flag_str(
    uint64_t component_flags);
















__declspec(dllimport)
char* ecs_id_str(
    const ecs_world_t *world,
    ecs_id_t component);








__declspec(dllimport)
void ecs_id_str_buf(
    const ecs_world_t *world,
    ecs_id_t component,
    ecs_strbuf_t *buf);









__declspec(dllimport)
ecs_id_t ecs_id_from_str(
    const ecs_world_t *world,
    const char *expr);
















__declspec(dllimport) 
_Bool ecs_term_ref_is_set(
    const ecs_term_ref_t *ref);












__declspec(dllimport)
_Bool ecs_term_is_initialized(
    const ecs_term_t *term);















__declspec(dllimport)
_Bool ecs_term_match_this(
    const ecs_term_t *term);













__declspec(dllimport)
_Bool ecs_term_match_0(
    const ecs_term_t *term);









__declspec(dllimport)
char* ecs_term_str(
    const ecs_world_t *world,
    const ecs_term_t *term);








__declspec(dllimport) 
char* ecs_query_str(
    const ecs_query_t *query); 









































__declspec(dllimport)
ecs_iter_t ecs_each_id(
    const ecs_world_t *world,
    ecs_id_t component);






__declspec(dllimport)
_Bool ecs_each_next(
    ecs_iter_t *it);























__declspec(dllimport)
 ecs_iter_t ecs_children(
    const ecs_world_t *world,
    ecs_entity_t parent);








__declspec(dllimport)
 ecs_iter_t ecs_children_w_rel(
    const ecs_world_t *world,
    ecs_entity_t relationship,
    ecs_entity_t parent);






__declspec(dllimport)
_Bool ecs_children_next(
    ecs_iter_t *it);



















__declspec(dllimport)
ecs_query_t* ecs_query_init(
    ecs_world_t *world,
    const ecs_query_desc_t *desc);











__declspec(dllimport)
ecs_query_t* ecs_query_update(
    ecs_world_t *world,
    ecs_entity_t entity,
    const ecs_query_desc_t *desc);





__declspec(dllimport)
void ecs_query_fini(
    ecs_query_t *query);











__declspec(dllimport)
int32_t ecs_query_find_var(
    const ecs_query_t *query,
    const char *name);    








__declspec(dllimport)
const char* ecs_query_var_name(
    const ecs_query_t *query,
    int32_t var_id);











__declspec(dllimport)
_Bool ecs_query_var_is_entity(
    const ecs_query_t *query,
    int32_t var_id);  







































































__declspec(dllimport)
ecs_iter_t ecs_query_iter(
    const ecs_world_t *world,
    const ecs_query_t *query);








__declspec(dllimport)
_Bool ecs_query_next(
    ecs_iter_t *it);



















__declspec(dllimport)
_Bool ecs_query_has(
    const ecs_query_t *query,
    ecs_entity_t entity,
    ecs_iter_t *it);



















__declspec(dllimport)
_Bool ecs_query_has_table(
    const ecs_query_t *query,
    ecs_table_t *table,
    ecs_iter_t *it);



























__declspec(dllimport)
_Bool ecs_query_has_range(
    const ecs_query_t *query,
    ecs_table_range_t *range,
    ecs_iter_t *it);










__declspec(dllimport)
int32_t ecs_query_match_count(
    const ecs_query_t *query);






__declspec(dllimport) extern const ecs_entity_t EcsOnQueryCacheRevalidate;


typedef struct ecs_query_cache_revalidate_t {
    ecs_entity_t query;              
    uint64_t table_id;               
} ecs_query_cache_revalidate_t;














__declspec(dllimport)
char* ecs_query_plan(
    const ecs_query_t *query);















__declspec(dllimport)
char* ecs_query_plan_w_profile(
    const ecs_query_t *query,
    const ecs_iter_t *it);






__declspec(dllimport)
char* ecs_query_plans(
    const ecs_query_t *query);


















__declspec(dllimport)
const char* ecs_query_args_parse(
    ecs_query_t *query,
    ecs_iter_t *it,
    const char *expr);


























__declspec(dllimport)
_Bool ecs_query_changed(
    ecs_query_t *query);










__declspec(dllimport)
const ecs_query_t* ecs_query_get(
    const ecs_world_t *world,
    ecs_entity_t query);












__declspec(dllimport)
void ecs_iter_skip(
    ecs_iter_t *it);























__declspec(dllimport)
void ecs_iter_set_group(
    ecs_iter_t *it,
    uint64_t group_id);


























__declspec(dllimport)
const ecs_map_t* ecs_query_get_groups(
    const ecs_query_t *query);









__declspec(dllimport)
void* ecs_query_get_group_ctx(
    const ecs_query_t *query,
    uint64_t group_id);









__declspec(dllimport)
const ecs_query_group_info_t* ecs_query_get_group_info(
    const ecs_query_t *query,
    uint64_t group_id);




typedef struct ecs_query_count_t {
    int32_t results;      
    int32_t entities;     
    int32_t tables;       


} ecs_query_count_t;







__declspec(dllimport)
ecs_query_count_t ecs_query_count(
    const ecs_query_t *query);






__declspec(dllimport)
_Bool ecs_query_is_true(
    const ecs_query_t *query);











__declspec(dllimport)
const ecs_query_t* ecs_query_get_cache_query(
    const ecs_query_t *query);































__declspec(dllimport)
void ecs_emit(
    ecs_world_t *world,
    ecs_event_desc_t *desc);











__declspec(dllimport)
void ecs_enqueue(
    ecs_world_t *world,
    ecs_event_desc_t *desc);















__declspec(dllimport)
ecs_entity_t ecs_observer_init(
    ecs_world_t *world,
    const ecs_observer_desc_t *desc);
















__declspec(dllimport)
ecs_entity_t ecs_observer_update(
    ecs_world_t *world,
    ecs_entity_t observer,
    const ecs_observer_desc_t *desc);









__declspec(dllimport)
const ecs_observer_t* ecs_observer_get(
    const ecs_world_t *world,
    ecs_entity_t observer);























__declspec(dllimport)
_Bool ecs_iter_next(
    ecs_iter_t *it);










__declspec(dllimport)
void ecs_iter_fini(
    ecs_iter_t *it);












__declspec(dllimport)
int32_t ecs_iter_count(
    ecs_iter_t *it);













__declspec(dllimport)
_Bool ecs_iter_is_true(
    ecs_iter_t *it);








__declspec(dllimport)
ecs_entity_t ecs_iter_first(
    ecs_iter_t *it);




































__declspec(dllimport)
void ecs_iter_set_var(
    ecs_iter_t *it,
    int32_t var_id,
    ecs_entity_t entity);











__declspec(dllimport)
void ecs_iter_set_var_as_table(
    ecs_iter_t *it,
    int32_t var_id,
    const ecs_table_t *table);











__declspec(dllimport)
void ecs_iter_set_var_as_range(
    ecs_iter_t *it,
    int32_t var_id,
    const ecs_table_range_t *range);















__declspec(dllimport)
ecs_entity_t ecs_iter_get_var(
    ecs_iter_t *it,
    int32_t var_id);







__declspec(dllimport)
const char* ecs_iter_get_var_name(
    const ecs_iter_t *it,
    int32_t var_id);






__declspec(dllimport)
int32_t ecs_iter_get_var_count(
    const ecs_iter_t *it);






__declspec(dllimport)
ecs_var_t* ecs_iter_get_vars(
    const ecs_iter_t *it);














__declspec(dllimport)
ecs_table_t* ecs_iter_get_var_as_table(
    ecs_iter_t *it,
    int32_t var_id);














__declspec(dllimport)
ecs_table_range_t ecs_iter_get_var_as_range(
    ecs_iter_t *it,
    int32_t var_id);












__declspec(dllimport)
_Bool ecs_iter_var_is_constrained(
    ecs_iter_t *it,
    int32_t var_id);
















__declspec(dllimport)
uint64_t ecs_iter_get_group(
    const ecs_iter_t *it);












__declspec(dllimport)
_Bool ecs_iter_changed(
    ecs_iter_t *it);

















__declspec(dllimport)
ecs_iter_t ecs_page_iter(
    const ecs_iter_t *it,
    int32_t offset,
    int32_t limit);







__declspec(dllimport)
_Bool ecs_page_next(
    ecs_iter_t *it);





















__declspec(dllimport)
ecs_iter_t ecs_worker_iter(
    const ecs_iter_t *it,
    int32_t index,
    int32_t count);







__declspec(dllimport)
_Bool ecs_worker_next(
    ecs_iter_t *it);










































__declspec(dllimport)
void* ecs_field_w_size(
    const ecs_iter_t *it,
    size_t size,
    int8_t index);























__declspec(dllimport)
void* ecs_field_at_w_size(
    const ecs_iter_t *it,
    size_t size,
    int8_t index,
    int32_t row);









__declspec(dllimport)
_Bool ecs_field_is_readonly(
    const ecs_iter_t *it,
    int8_t index);











__declspec(dllimport)
_Bool ecs_field_is_writeonly(
    const ecs_iter_t *it,
    int8_t index);







__declspec(dllimport)
_Bool ecs_field_is_set(
    const ecs_iter_t *it,
    int8_t index);







__declspec(dllimport)
ecs_id_t ecs_field_id(
    const ecs_iter_t *it,
    int8_t index);









__declspec(dllimport)
int32_t ecs_field_column(
    const ecs_iter_t *it,
    int8_t index);








__declspec(dllimport)
ecs_entity_t ecs_field_src(
    const ecs_iter_t *it,
    int8_t index);








__declspec(dllimport)
size_t ecs_field_size(
    const ecs_iter_t *it,
    int8_t index);














__declspec(dllimport)
_Bool ecs_field_is_self(
    const ecs_iter_t *it,
    int8_t index);
















__declspec(dllimport)
const ecs_type_t* ecs_table_get_type(
    const ecs_table_t *table);











__declspec(dllimport)
int32_t ecs_table_get_type_index(
    const ecs_world_t *world,
    const ecs_table_t *table,
    ecs_id_t component);










__declspec(dllimport)
int32_t ecs_table_get_column_index(
    const ecs_world_t *world,
    const ecs_table_t *table,
    ecs_id_t component);








__declspec(dllimport)
int32_t ecs_table_column_count(
    const ecs_table_t *table);














__declspec(dllimport)
int32_t ecs_table_type_to_column_index(
    const ecs_table_t *table,
    int32_t index);









__declspec(dllimport)
int32_t ecs_table_column_to_type_index(
    const ecs_table_t *table,
    int32_t index);









__declspec(dllimport)
void* ecs_table_get_column(
    const ecs_table_t *table,
    int32_t index,
    int32_t offset);










__declspec(dllimport)
void* ecs_table_get_id(
    const ecs_world_t *world,
    const ecs_table_t *table,
    ecs_id_t component,
    int32_t offset);








__declspec(dllimport)
size_t ecs_table_get_column_size(
    const ecs_table_t *table,
    int32_t index);







__declspec(dllimport)
int32_t ecs_table_count(
    const ecs_table_t *table);








__declspec(dllimport)
int32_t ecs_table_size(
    const ecs_table_t *table);







__declspec(dllimport)
const ecs_entity_t* ecs_table_entities(
    const ecs_table_t *table);











__declspec(dllimport)
_Bool ecs_table_has_id(
    const ecs_world_t *world,
    const ecs_table_t *table,
    ecs_id_t component);











__declspec(dllimport)
ecs_entity_t ecs_table_get_target(
    const ecs_world_t *world,
    const ecs_table_t *table,
    ecs_entity_t relationship,
    int32_t index);











__declspec(dllimport)
int32_t ecs_table_get_depth(
    const ecs_world_t *world,
    const ecs_table_t *table,
    ecs_entity_t rel);










__declspec(dllimport)
ecs_table_t* ecs_table_add_id(
    ecs_world_t *world,
    ecs_table_t *table,
    ecs_id_t component);











__declspec(dllimport)
ecs_table_t* ecs_table_find(
    ecs_world_t *world,
    const ecs_id_t *ids,
    int32_t id_count);










__declspec(dllimport)
ecs_table_t* ecs_table_remove_id(
    ecs_world_t *world,
    ecs_table_t *table,
    ecs_id_t component);
















__declspec(dllimport)
void ecs_table_lock(
    ecs_world_t *world,
    ecs_table_t *table);







__declspec(dllimport)
void ecs_table_unlock(
    ecs_world_t *world,
    ecs_table_t *table);










__declspec(dllimport)
_Bool ecs_table_has_flags(
    ecs_table_t *table,
    ecs_flags32_t flags);








__declspec(dllimport)
_Bool ecs_table_has_traversable(
    const ecs_table_t *table);










__declspec(dllimport)
void ecs_table_swap_rows(
    ecs_world_t* world,
    ecs_table_t* table,
    int32_t row_1,
    int32_t row_2);




















__declspec(dllimport)
int32_t ecs_search(
    const ecs_world_t *world,
    const ecs_table_t *table,
    ecs_id_t component,
    ecs_id_t *component_out);




































__declspec(dllimport)
int32_t ecs_search_offset(
    const ecs_world_t *world,
    const ecs_table_t *table,
    int32_t offset,
    ecs_id_t component,
    ecs_id_t *component_out);









































__declspec(dllimport)
int32_t ecs_search_relation(
    const ecs_world_t *world,
    const ecs_table_t *table,
    int32_t offset,
    ecs_id_t component,
    ecs_entity_t rel,
    ecs_flags64_t flags, 
    ecs_entity_t *tgt_out,
    ecs_id_t *component_out,
    struct ecs_table_record_t **tr_out);
















__declspec(dllimport)
int32_t ecs_search_relation_for_entity(
    const ecs_world_t *world,
    ecs_entity_t entity,
    ecs_id_t id,
    ecs_entity_t rel,
    _Bool self,
    ecs_component_record_t *cr,
    ecs_entity_t *tgt_out,
    ecs_id_t *id_out,
    struct ecs_table_record_t **tr_out);








__declspec(dllimport)
void ecs_table_clear_entities(
    ecs_world_t* world,
    ecs_table_t* table);












































































































































































































































































































































































































































































































































































































































































































































































































































































































































































__declspec(dllimport)
void ecs_deprecated_(
    const char *file,
    int32_t line,
    const char *msg);







__declspec(dllimport)
void ecs_log_push_(int32_t level);







__declspec(dllimport)
void ecs_log_pop_(int32_t level);








__declspec(dllimport)
_Bool ecs_should_log(int32_t level);










__declspec(dllimport)
const char* ecs_strerror(
    int32_t error_code);
































__declspec(dllimport)
void ecs_print_(
    int32_t level,
    const char *file,
    int32_t line,
    const char *fmt,
    ...);









__declspec(dllimport)
void ecs_printv_(
    int level,
    const char *file,
    int32_t line,
    const char *fmt,
    va_list args);








__declspec(dllimport)
void ecs_log_(
    int32_t level,
    const char *file,
    int32_t line,
    const char *fmt,
    ...);









__declspec(dllimport)
void ecs_logv_(
    int level,
    const char *file,
    int32_t line,
    const char *fmt,
    va_list args);








__declspec(dllimport)
void ecs_abort_(
    int32_t error_code,
    const char *file,
    int32_t line,
    const char *fmt,
    ...);









__declspec(dllimport)
void ecs_assert_log_(
    int32_t error_code,
    const char *condition_str,
    const char *file,
    int32_t line,
    const char *fmt,
    ...);








__declspec(dllimport)
void ecs_parser_error_(
    const char *name,
    const char *expr,
    int64_t column,
    const char *fmt,
    ...);









__declspec(dllimport)
void ecs_parser_errorv_(
    const char *name,
    const char *expr,
    int64_t column,
    const char *fmt,
    va_list args);








__declspec(dllimport)
void ecs_parser_warning_(
    const char *name,
    const char *expr,
    int64_t column,
    const char *fmt,
    ...);









__declspec(dllimport)
void ecs_parser_warningv_(
    const char *name,
    const char *expr,
    int64_t column,
    const char *fmt,
    va_list args);




















































































































































































































































































































__declspec(dllimport)
int ecs_log_set_level(
    int level);





__declspec(dllimport)
int ecs_log_get_level(void);







__declspec(dllimport)
_Bool ecs_log_enable_colors(
    _Bool enabled);








__declspec(dllimport)
_Bool ecs_log_enable_timestamp(
    _Bool enabled);














__declspec(dllimport)
_Bool ecs_log_enable_timedelta(
    _Bool enabled);






__declspec(dllimport)
int ecs_log_last_error(void);





__declspec(dllimport)
void ecs_log_start_capture(_Bool capture_try);





__declspec(dllimport)
char* ecs_log_stop_capture(void);


















































































































































__declspec(dllimport) extern const ecs_entity_t EcsFinal;








__declspec(dllimport) extern const ecs_entity_t EcsSymmetric;


__declspec(dllimport) extern const ecs_entity_t EcsAcyclic;










__declspec(dllimport) extern const ecs_entity_t EcsOneOf;




__declspec(dllimport) extern const ecs_entity_t EcsTrait;










__declspec(dllimport) extern const ecs_entity_t EcsRelationship;










__declspec(dllimport) extern const ecs_entity_t EcsTarget;



__declspec(dllimport) extern const ecs_entity_t EcsSingleton;






































typedef struct ecs_entity_range_t {
    uint32_t min;           
    uint32_t max;           
    uint32_t cur;           
    ecs_vec_t recycled;     
} ecs_entity_range_t;















__declspec(dllimport)
const ecs_entity_range_t* ecs_entity_range_new(
    ecs_world_t *world,
    uint32_t min,
    uint32_t max);















__declspec(dllimport)
void ecs_entity_range_set(
    ecs_world_t *world,
    const ecs_entity_range_t *range);








__declspec(dllimport)
const ecs_entity_range_t* ecs_entity_range_get(
    const ecs_world_t *world);

























































__declspec(dllimport)
float ecs_frame_begin(
    ecs_world_t *world,
    float delta_time);







__declspec(dllimport)
void ecs_frame_end(
    ecs_world_t *world);









__declspec(dllimport)
void ecs_run_post_frame(
    ecs_world_t *world,
    ecs_fini_action_t action,
    void *ctx);







__declspec(dllimport)
void ecs_quit(
    ecs_world_t *world);







__declspec(dllimport)
_Bool ecs_should_quit(
    const ecs_world_t *world);












__declspec(dllimport)
void ecs_measure_frame_time(
    ecs_world_t *world,
    _Bool enable);











__declspec(dllimport)
void ecs_measure_system_time(
    ecs_world_t *world,
    _Bool enable);















__declspec(dllimport)
void ecs_set_target_fps(
    ecs_world_t *world,
    float fps);







__declspec(dllimport)
void ecs_set_time_scale(
    ecs_world_t *world,
    float scale);






__declspec(dllimport)
void ecs_reset_clock(
    ecs_world_t *world);








































typedef int(*ecs_app_init_action_t)(
    ecs_world_t *world);


typedef struct ecs_app_desc_t {
    float target_fps;   
    float delta_time;   
    int32_t threads;          
    int32_t frames;           
    _Bool enable_rest;         
    _Bool enable_stats;      
    uint16_t port;            

    ecs_app_init_action_t init; 


    void *ctx;                
} ecs_app_desc_t;


typedef int(*ecs_app_run_action_t)(
    ecs_world_t *world,
    ecs_app_desc_t *desc);


typedef int(*ecs_app_frame_action_t)(
    ecs_world_t *world,
    const ecs_app_desc_t *desc);













__declspec(dllimport)
int ecs_app_run(
    ecs_world_t *world,
    ecs_app_desc_t *desc);









__declspec(dllimport)
int ecs_app_run_frame(
    ecs_world_t *world,
    const ecs_app_desc_t *desc);







__declspec(dllimport)
int ecs_app_set_run_action(
    ecs_app_run_action_t callback);







__declspec(dllimport)
int ecs_app_set_frame_action(
    ecs_app_frame_action_t callback);














































typedef struct ecs_http_server_t ecs_http_server_t;


typedef struct {
    uint64_t id;                   
    ecs_http_server_t *server;     

    char host[128];                
    char port[16];                 
} ecs_http_connection_t;


typedef struct {
    const char *key;               
    const char *value;             
} ecs_http_key_value_t;


typedef enum {
    EcsHttpGet,
    EcsHttpPost,
    EcsHttpPut,
    EcsHttpDelete,
    EcsHttpOptions,
    EcsHttpMethodUnsupported
} ecs_http_method_t;


typedef struct {
    uint64_t id;                   

    ecs_http_method_t method;      
    char *path;                    
    char *body;                    
    ecs_http_key_value_t headers[(32)]; 
    ecs_http_key_value_t params[(32)];  
    int32_t header_count;          
    int32_t param_count;           

    ecs_http_connection_t *conn;   
} ecs_http_request_t;


typedef struct {
    int code;                   
    ecs_strbuf_t body;          
    const char* status;         
    const char* content_type;   
    ecs_strbuf_t headers;       
} ecs_http_reply_t;






extern int64_t ecs_http_request_received_count;       
extern int64_t ecs_http_request_invalid_count;        
extern int64_t ecs_http_request_handled_ok_count;     
extern int64_t ecs_http_request_handled_error_count;  
extern int64_t ecs_http_request_not_handled_count;    
extern int64_t ecs_http_request_preflight_count;      
extern int64_t ecs_http_send_ok_count;                
extern int64_t ecs_http_send_error_count;             
extern int64_t ecs_http_busy_count;                   





typedef _Bool (*ecs_http_reply_action_t)(
    const ecs_http_request_t* request,
    ecs_http_reply_t *reply,
    void *ctx);


typedef struct {
    ecs_http_reply_action_t callback; 
    void *ctx;                        
    uint16_t port;                    
    const char *ipaddr;               
    int32_t send_queue_wait_ms;       
    double cache_timeout;             
    double cache_purge_timeout;       
} ecs_http_server_desc_t;







__declspec(dllimport)
ecs_http_server_t* ecs_http_server_init(
    const ecs_http_server_desc_t *desc);






__declspec(dllimport)
void ecs_http_server_fini(
    ecs_http_server_t* server);







__declspec(dllimport)
int ecs_http_server_start(
    ecs_http_server_t* server);








__declspec(dllimport)
void ecs_http_server_dequeue(
    ecs_http_server_t* server,
    float delta_time);






__declspec(dllimport)
void ecs_http_server_stop(
    ecs_http_server_t* server);












__declspec(dllimport)
int ecs_http_server_http_request(
    ecs_http_server_t* srv,
    const char *req,
    ecs_size_t len,
    ecs_http_reply_t *reply_out);










__declspec(dllimport)
int ecs_http_server_request(
    ecs_http_server_t* srv,
    const char *method,
    const char *req,
    const char *body,
    ecs_http_reply_t *reply_out);






__declspec(dllimport)
void* ecs_http_server_ctx(
    ecs_http_server_t* srv);







__declspec(dllimport)
const char* ecs_http_get_header(
    const ecs_http_request_t* req,
    const char* name);







__declspec(dllimport)
const char* ecs_http_get_param(
    const ecs_http_request_t* req,
    const char* name);






















































__declspec(dllimport) extern const ecs_entity_t FLECS_IDEcsRestID_;


typedef struct {
    ecs_world_t *world;            
    ecs_http_server_t *srv;        
    int32_t rc;                    
    ecs_map_t cmd_captures;        
    double last_time;              
} ecs_rest_ctx_t;


typedef struct {
    uint16_t port;      
    char *ipaddr;       
    ecs_rest_ctx_t *impl; 
} EcsRest;









__declspec(dllimport)
ecs_http_server_t* ecs_rest_server_init(
    ecs_world_t *world,
    const ecs_http_server_desc_t *desc);






__declspec(dllimport)
void ecs_rest_server_fini(
    ecs_http_server_t *srv);









__declspec(dllimport)
void FlecsRestImport(
    ecs_world_t *world);












































typedef struct EcsTimer {
    float timeout;         
    float time;            
    float overshoot;       
    int32_t fired_count;         
    _Bool active;                 
    _Bool single_shot;            
} EcsTimer;


typedef struct EcsRateFilter {
    ecs_entity_t src;            
    int32_t rate;                
    int32_t tick_count;          
    float time_elapsed;    
} EcsRateFilter;



















__declspec(dllimport)
ecs_entity_t ecs_set_timeout(
    ecs_world_t *world,
    ecs_entity_t tick_source,
    float timeout);













__declspec(dllimport)
float ecs_get_timeout(
    const ecs_world_t *world,
    ecs_entity_t tick_source);


















__declspec(dllimport)
ecs_entity_t ecs_set_interval(
    ecs_world_t *world,
    ecs_entity_t tick_source,
    float interval);









__declspec(dllimport)
float ecs_get_interval(
    const ecs_world_t *world,
    ecs_entity_t tick_source);







__declspec(dllimport)
void ecs_start_timer(
    ecs_world_t *world,
    ecs_entity_t tick_source);







__declspec(dllimport)
void ecs_stop_timer(
    ecs_world_t *world,
    ecs_entity_t tick_source);







__declspec(dllimport)
void ecs_reset_timer(
    ecs_world_t *world,
    ecs_entity_t tick_source);







__declspec(dllimport)
void ecs_randomize_timers(
    ecs_world_t *world);































__declspec(dllimport)
ecs_entity_t ecs_set_rate(
    ecs_world_t *world,
    ecs_entity_t tick_source,
    int32_t rate,
    ecs_entity_t source);























__declspec(dllimport)
void ecs_set_tick_source(
    ecs_world_t *world,
    ecs_entity_t system,
    ecs_entity_t tick_source);













__declspec(dllimport)
void FlecsTimerImport(
    ecs_world_t *world);


























































































typedef struct ecs_pipeline_desc_t {
    
    ecs_entity_t entity;

    






















    ecs_query_desc_t query;
} ecs_pipeline_desc_t;










__declspec(dllimport)
ecs_entity_t ecs_pipeline_init(
    ecs_world_t *world,
    const ecs_pipeline_desc_t *desc);










__declspec(dllimport)
ecs_entity_t ecs_pipeline_update(
    ecs_world_t *world,
    ecs_entity_t pipeline,
    const ecs_pipeline_desc_t *desc);







__declspec(dllimport)
void ecs_set_pipeline(
    ecs_world_t *world,
    ecs_entity_t pipeline);







__declspec(dllimport)
ecs_entity_t ecs_get_pipeline(
    const ecs_world_t *world);



















__declspec(dllimport)
_Bool ecs_progress(
    ecs_world_t *world,
    float delta_time);

















__declspec(dllimport)
void ecs_run_pipeline(
    ecs_world_t *world,
    ecs_entity_t pipeline,
    float delta_time);
















__declspec(dllimport)
void ecs_set_threads(
    ecs_world_t *world,
    int32_t threads);

















__declspec(dllimport)
void ecs_set_task_threads(
    ecs_world_t *world,
    int32_t task_threads);






__declspec(dllimport)
_Bool ecs_using_task_threads(
    ecs_world_t *world);













__declspec(dllimport)
void FlecsPipelineImport(
    ecs_world_t *world);








































typedef struct EcsTickSource {
    _Bool tick;                 
    float time_elapsed;  
} EcsTickSource;


typedef struct ecs_system_desc_t {
    int32_t _canary;       

    
    ecs_entity_t entity;

    
    ecs_query_desc_t query;

    

    ecs_entity_t phase;

    


    ecs_iter_action_t callback;

    










    ecs_run_action_t run;

    
    void *ctx;

    
    ecs_ctx_free_t ctx_free;

    
    void *callback_ctx;

    
    ecs_ctx_free_t callback_ctx_free;

    
    void *run_ctx;

    
    ecs_ctx_free_t run_ctx_free;
    
    
    float interval;

    
    int32_t rate;

    
    ecs_entity_t tick_source;

    
    _Bool multi_threaded;

    

    _Bool immediate;
} ecs_system_desc_t;










__declspec(dllimport)
ecs_entity_t ecs_system_init(
    ecs_world_t *world,
    const ecs_system_desc_t *desc);















__declspec(dllimport)
ecs_entity_t ecs_system_update(
    ecs_world_t *world,
    ecs_entity_t system,
    const ecs_system_desc_t *desc);


typedef struct ecs_system_t {
    ecs_header_t hdr;              

    
    ecs_run_action_t run;

    
    ecs_iter_action_t action;

    
    ecs_query_t *query;

    
    uint64_t group_id;

    
    _Bool group_id_set;

    
    ecs_entity_t tick_source;

    
    _Bool multi_threaded;

    
    _Bool immediate;

    
    const char *name;

    
    void *ctx;

    
    void *callback_ctx;

    
    void *run_ctx;

    
    ecs_ctx_free_t ctx_free;

    
    ecs_ctx_free_t callback_ctx_free;

    
    ecs_ctx_free_t run_ctx_free;

    
    float time_spent;

    
    float time_passed;

    
    int64_t last_frame;

    
    flecs_poly_dtor_t dtor;
} ecs_system_t;









__declspec(dllimport)
const ecs_system_t* ecs_system_get(
    const ecs_world_t *world,
    ecs_entity_t system);










__declspec(dllimport)
void ecs_system_set_group(
    ecs_world_t *world,
    ecs_entity_t system,
    uint64_t group_id);


























































































__declspec(dllimport)
ecs_entity_t ecs_run(
    ecs_world_t *world,
    ecs_entity_t system,
    float delta_time,
    void *param);











__declspec(dllimport)
ecs_entity_t ecs_run_worker(
    ecs_world_t *world,
    ecs_entity_t system,
    int32_t stage_current,
    int32_t stage_count,
    float delta_time,
    void *param);









__declspec(dllimport)
void FlecsSystemImport(
    ecs_world_t *world);















































typedef struct ecs_gauge_t {
    float avg[(60)];   
    float min[(60)];   
    float max[(60)];   
} ecs_gauge_t;


typedef struct ecs_counter_t {
    ecs_gauge_t rate;                     
    double value[(60)];        
} ecs_counter_t;


typedef union ecs_metric_t {
    ecs_gauge_t gauge;                    
    ecs_counter_t counter;                
} ecs_metric_t;


typedef struct ecs_world_stats_t {
    int64_t first_;                       

    
    struct {
        ecs_metric_t count;               
        ecs_metric_t not_alive_count;     
    } entities;

    
    struct {
        ecs_metric_t tag_count;           
        ecs_metric_t component_count;     
        ecs_metric_t pair_count;          
        ecs_metric_t type_count;          
        ecs_metric_t create_count;        
        ecs_metric_t delete_count;        
    } components;

    
    struct {
        ecs_metric_t count;                
        ecs_metric_t empty_count;          
        ecs_metric_t create_count;         
        ecs_metric_t delete_count;         
    } tables;

    
    struct {
        ecs_metric_t query_count;          
        ecs_metric_t observer_count;       
        ecs_metric_t system_count;         
    } queries;

    
    struct {
        ecs_metric_t add_count;            
        ecs_metric_t remove_count;         
        ecs_metric_t delete_count;         
        ecs_metric_t clear_count;          
        ecs_metric_t set_count;            
        ecs_metric_t ensure_count;         
        ecs_metric_t modified_count;       
        ecs_metric_t other_count;          
        ecs_metric_t discard_count;        
        ecs_metric_t batched_entity_count; 
        ecs_metric_t batched_count;        
    } commands;

    
    struct {
        ecs_metric_t frame_count;          
        ecs_metric_t merge_count;          
        ecs_metric_t rematch_count;        
        ecs_metric_t pipeline_build_count; 
        ecs_metric_t systems_ran;          
        ecs_metric_t observers_ran;        
        ecs_metric_t event_emit_count;     
    } frame;

    
    struct {
        ecs_metric_t world_time_raw;       
        ecs_metric_t world_time;           
        ecs_metric_t frame_time;           
        ecs_metric_t system_time;          
        ecs_metric_t emit_time;            
        ecs_metric_t merge_time;           
        ecs_metric_t rematch_time;         
        ecs_metric_t fps;                  
        ecs_metric_t delta_time;           
    } performance;

    struct {
        
        ecs_metric_t alloc_count;          
        ecs_metric_t realloc_count;        
        ecs_metric_t free_count;           
        ecs_metric_t outstanding_alloc_count; 

        
        ecs_metric_t block_alloc_count;    
        ecs_metric_t block_free_count;     
        ecs_metric_t block_outstanding_alloc_count; 
        ecs_metric_t stack_alloc_count;    
        ecs_metric_t stack_free_count;     
        ecs_metric_t stack_outstanding_alloc_count; 
    } memory;

    
    struct {
        ecs_metric_t request_received_count;       
        ecs_metric_t request_invalid_count;        
        ecs_metric_t request_handled_ok_count;     
        ecs_metric_t request_handled_error_count;  
        ecs_metric_t request_not_handled_count;    
        ecs_metric_t request_preflight_count;      
        ecs_metric_t send_ok_count;                
        ecs_metric_t send_error_count;             
        ecs_metric_t busy_count;                   
    } http;

    int64_t last_;                                 

    
    int32_t t;
} ecs_world_stats_t;


typedef struct ecs_query_stats_t {
    int64_t first_;                         
    ecs_metric_t result_count;              
    ecs_metric_t matched_table_count;       
    ecs_metric_t matched_entity_count;      
    int64_t last_;                          

    
    int32_t t; 
} ecs_query_stats_t;


typedef struct ecs_system_stats_t {
    int64_t first_;                
    ecs_metric_t time_spent;       
    int64_t last_;                 

    _Bool task;                     

    ecs_query_stats_t query;       
} ecs_system_stats_t;


typedef struct ecs_sync_stats_t {
    int64_t first_;                
    ecs_metric_t time_spent;       
    ecs_metric_t commands_enqueued; 
    int64_t last_;                 

    int32_t system_count;          
    _Bool multi_threaded;           
    _Bool immediate;                
} ecs_sync_stats_t;


typedef struct ecs_pipeline_stats_t {
    int8_t canary_;                

    

    ecs_vec_t systems;

    
    ecs_vec_t sync_points;

    
    int32_t t;

    int32_t system_count;        
    int32_t active_system_count; 
    int32_t rebuild_count;       
} ecs_pipeline_stats_t;






__declspec(dllimport)
void ecs_world_stats_get(
    const ecs_world_t *world,
    ecs_world_stats_t *stats);


__declspec(dllimport)
void ecs_world_stats_reduce(
    ecs_world_stats_t *dst,
    const ecs_world_stats_t *src);


__declspec(dllimport)
void ecs_world_stats_reduce_last(
    ecs_world_stats_t *stats,
    const ecs_world_stats_t *old,
    int32_t count);


__declspec(dllimport)
void ecs_world_stats_repeat_last(
    ecs_world_stats_t *stats);


__declspec(dllimport)
void ecs_world_stats_copy_last(
    ecs_world_stats_t *dst,
    const ecs_world_stats_t *src);






__declspec(dllimport)
void ecs_world_stats_log(
    const ecs_world_t *world,
    const ecs_world_stats_t *stats);








__declspec(dllimport)
void ecs_query_stats_get(
    const ecs_world_t *world,
    const ecs_query_t *query,
    ecs_query_stats_t *stats);


__declspec(dllimport) 
void ecs_query_cache_stats_reduce(
    ecs_query_stats_t *dst,
    const ecs_query_stats_t *src);


__declspec(dllimport)
void ecs_query_cache_stats_reduce_last(
    ecs_query_stats_t *stats,
    const ecs_query_stats_t *old,
    int32_t count);


__declspec(dllimport)
void ecs_query_cache_stats_repeat_last(
    ecs_query_stats_t *stats);


__declspec(dllimport)
void ecs_query_cache_stats_copy_last(
    ecs_query_stats_t *dst,
    const ecs_query_stats_t *src);









__declspec(dllimport)
_Bool ecs_system_stats_get(
    const ecs_world_t *world,
    ecs_entity_t system,
    ecs_system_stats_t *stats);


__declspec(dllimport)
void ecs_system_stats_reduce(
    ecs_system_stats_t *dst,
    const ecs_system_stats_t *src);


__declspec(dllimport)
void ecs_system_stats_reduce_last(
    ecs_system_stats_t *stats,
    const ecs_system_stats_t *old,
    int32_t count);


__declspec(dllimport)
void ecs_system_stats_repeat_last(
    ecs_system_stats_t *stats);


__declspec(dllimport)
void ecs_system_stats_copy_last(
    ecs_system_stats_t *dst,
    const ecs_system_stats_t *src);









__declspec(dllimport)
_Bool ecs_pipeline_stats_get(
    ecs_world_t *world,
    ecs_entity_t pipeline,
    ecs_pipeline_stats_t *stats);





__declspec(dllimport)
void ecs_pipeline_stats_fini(
    ecs_pipeline_stats_t *stats);


__declspec(dllimport)
void ecs_pipeline_stats_reduce(
    ecs_pipeline_stats_t *dst,
    const ecs_pipeline_stats_t *src);


__declspec(dllimport)
void ecs_pipeline_stats_reduce_last(
    ecs_pipeline_stats_t *stats,
    const ecs_pipeline_stats_t *old,
    int32_t count);


__declspec(dllimport)
void ecs_pipeline_stats_repeat_last(
    ecs_pipeline_stats_t *stats);








__declspec(dllimport)
void ecs_pipeline_stats_copy_last(
    ecs_pipeline_stats_t *dst,
    const ecs_pipeline_stats_t *src);


__declspec(dllimport)
void ecs_metric_reduce(
    ecs_metric_t *dst,
    const ecs_metric_t *src,
    int32_t t_dst,
    int32_t t_src);


__declspec(dllimport)
void ecs_metric_reduce_last(
    ecs_metric_t *m,
    int32_t t,
    int32_t count);


__declspec(dllimport)
void ecs_metric_copy(
    ecs_metric_t *m,
    int32_t dst,
    int32_t src);

__declspec(dllimport) extern ecs_entity_t FLECS_IDFlecsStatsID_;        
__declspec(dllimport) extern ecs_entity_t FLECS_IDEcsWorldStatsID_;     
__declspec(dllimport) extern ecs_entity_t FLECS_IDEcsWorldSummaryID_;   
__declspec(dllimport) extern ecs_entity_t FLECS_IDEcsSystemStatsID_;    
__declspec(dllimport) extern ecs_entity_t FLECS_IDEcsPipelineStatsID_;  


__declspec(dllimport) extern ecs_entity_t FLECS_IDecs_entities_memory_tID_;    
__declspec(dllimport) extern ecs_entity_t FLECS_IDecs_component_index_memory_tID_; 
__declspec(dllimport) extern ecs_entity_t FLECS_IDecs_query_memory_tID_;           
__declspec(dllimport) extern ecs_entity_t FLECS_IDecs_component_memory_tID_;       
__declspec(dllimport) extern ecs_entity_t FLECS_IDecs_table_memory_tID_;           
__declspec(dllimport) extern ecs_entity_t FLECS_IDecs_misc_memory_tID_;        
__declspec(dllimport) extern ecs_entity_t FLECS_IDecs_table_histogram_tID_;        
__declspec(dllimport) extern ecs_entity_t FLECS_IDecs_allocator_memory_tID_; 
__declspec(dllimport) extern ecs_entity_t FLECS_IDEcsWorldMemoryID_;               

__declspec(dllimport) extern ecs_entity_t EcsPeriod1s;                 
__declspec(dllimport) extern ecs_entity_t EcsPeriod1m;                 
__declspec(dllimport) extern ecs_entity_t EcsPeriod1h;                 
__declspec(dllimport) extern ecs_entity_t EcsPeriod1d;                 
__declspec(dllimport) extern ecs_entity_t EcsPeriod1w;                 


typedef struct {
    float elapsed;       
    int32_t reduce_count;      
} EcsStatsHeader;


typedef struct {
    EcsStatsHeader hdr;            
    ecs_world_stats_t *stats;      
} EcsWorldStats;


typedef struct {
    EcsStatsHeader hdr;            
    ecs_map_t stats;               
} EcsSystemStats;


typedef struct {
    EcsStatsHeader hdr;            
    ecs_map_t stats;               
} EcsPipelineStats;


typedef struct {
    
    double target_fps;          
    double time_scale;          
    double fps;                 

    
    double frame_time_total;    
    double system_time_total;   
    double merge_time_total;    

    int64_t entity_count;       
    int64_t table_count;        
    int64_t frame_count;        
    int64_t command_count;      
    int64_t merge_count;        

    int64_t systems_ran_total;   
    int64_t observers_ran_total; 
    int64_t queries_ran_total;   

    int32_t tag_count;           
    int32_t component_count;     
    int32_t pair_count;          

    
    double frame_time_frame;    
    double system_time_frame;   
    double merge_time_frame;    

    int64_t merge_count_frame;   
    int64_t systems_ran_frame;   
    int64_t observers_ran_frame; 
    int64_t queries_ran_frame;   
    int64_t command_count_frame; 

    double simulation_time;     
    uint32_t uptime;            

    
    ecs_build_info_t build_info; 
} EcsWorldSummary;


typedef struct {
    int32_t alive_count;                 
    int32_t not_alive_count;             
    ecs_size_t bytes_entity_index;       
    ecs_size_t bytes_names;              
    ecs_size_t bytes_doc_strings;        
} ecs_entities_memory_t;


typedef struct {
    int32_t instances;                  
    ecs_size_t bytes_table_components;  
    ecs_size_t bytes_table_components_unused; 
    ecs_size_t bytes_toggle_bitsets;    
    ecs_size_t bytes_sparse_components; 
} ecs_component_memory_t;


typedef struct {
    int32_t count;                      
    ecs_size_t bytes_component_record;  
    ecs_size_t bytes_table_cache;       
    ecs_size_t bytes_name_index;        
    ecs_size_t bytes_ordered_children;  
    ecs_size_t bytes_children_table_map; 
    ecs_size_t bytes_reachable_cache;   
} ecs_component_index_memory_t;


typedef struct {
    int32_t count;                      
    int32_t cached_count;               
    ecs_size_t bytes_query;             
    ecs_size_t bytes_cache;             
    ecs_size_t bytes_group_by;          
    ecs_size_t bytes_order_by;          
    ecs_size_t bytes_plan;              
    ecs_size_t bytes_terms;             
    ecs_size_t bytes_misc;              
} ecs_query_memory_t;






typedef struct {
    int32_t count;                      
    int32_t empty_count;                
    int32_t column_count;               
    ecs_size_t bytes_table;             
    ecs_size_t bytes_type;              
    ecs_size_t bytes_entities;          
    ecs_size_t bytes_overrides;         
    ecs_size_t bytes_column_map;        
    ecs_size_t bytes_component_map;     
    ecs_size_t bytes_dirty_state;       
    ecs_size_t bytes_edges;             
} ecs_table_memory_t;


typedef struct {
    int32_t entity_counts[14]; 
} ecs_table_histogram_t;


typedef struct {
    ecs_size_t bytes_world;             
    ecs_size_t bytes_observers;         
    ecs_size_t bytes_systems;           
    ecs_size_t bytes_pipelines;         
    ecs_size_t bytes_table_lookup;      
    ecs_size_t bytes_component_record_lookup; 
    ecs_size_t bytes_locked_components; 
    ecs_size_t bytes_type_info;         
    ecs_size_t bytes_commands;          
    ecs_size_t bytes_rematch_monitor;   
    ecs_size_t bytes_component_ids;     
    ecs_size_t bytes_reflection;        
    ecs_size_t bytes_tree_spawner;      
    ecs_size_t bytes_prefab_child_indices; 
    ecs_size_t bytes_stats;             
    ecs_size_t bytes_rest;              
} ecs_misc_memory_t;



typedef struct {
    ecs_size_t bytes_graph_edge;        
    ecs_size_t bytes_component_record;  
    ecs_size_t bytes_pair_record;       
    ecs_size_t bytes_table_diff;        
    ecs_size_t bytes_sparse_chunk;      
    ecs_size_t bytes_allocator;         
    ecs_size_t bytes_stack_allocator;   
    ecs_size_t bytes_cmd_entry_chunk;   
    ecs_size_t bytes_query_impl;        
    ecs_size_t bytes_query_cache;       
    ecs_size_t bytes_misc;              
} ecs_allocator_memory_t;


typedef struct {
    ecs_entities_memory_t entities;                    
    ecs_component_memory_t components;                  
    ecs_component_index_memory_t component_index;       
    ecs_query_memory_t queries;                         
    ecs_table_memory_t tables;                          
    ecs_table_histogram_t table_histogram;              
    ecs_misc_memory_t misc;                             
    ecs_allocator_memory_t allocators;                  
    double collection_time; 
} EcsWorldMemory;






__declspec(dllimport)
ecs_entities_memory_t ecs_entity_memory_get(
    const ecs_world_t *world);






void ecs_component_record_memory_get(
    const ecs_component_record_t *cr,
    ecs_component_index_memory_t *result);






__declspec(dllimport)
ecs_component_index_memory_t ecs_component_index_memory_get(
    const ecs_world_t *world);






__declspec(dllimport)
void ecs_query_memory_get(
    const ecs_query_t *query,
    ecs_query_memory_t *result);






__declspec(dllimport)
ecs_query_memory_t ecs_queries_memory_get(
    const ecs_world_t *world);






void ecs_table_component_memory_get(
    const ecs_table_t *table,
    ecs_component_memory_t *result);






__declspec(dllimport)
ecs_component_memory_t ecs_component_memory_get(
    const ecs_world_t *world);






void ecs_table_memory_get(
    const ecs_table_t *table,
    ecs_table_memory_t *result);






__declspec(dllimport)
ecs_table_memory_t ecs_tables_memory_get(
    const ecs_world_t *world);






__declspec(dllimport)
ecs_table_histogram_t ecs_table_histogram_get(
    const ecs_world_t *world);






__declspec(dllimport)
ecs_misc_memory_t ecs_misc_memory_get(
    const ecs_world_t *world);






__declspec(dllimport)
ecs_allocator_memory_t ecs_allocator_memory_get(
    const ecs_world_t *world);






__declspec(dllimport)
ecs_size_t ecs_memory_get(
    const ecs_world_t *world);









__declspec(dllimport)
void FlecsStatsImport(
    ecs_world_t *world);
















































__declspec(dllimport) extern ecs_entity_t FLECS_IDFlecsMetricsID_;


__declspec(dllimport) extern ecs_entity_t EcsMetric, FLECS_IDEcsMetricID_;


__declspec(dllimport) extern ecs_entity_t EcsCounter, FLECS_IDEcsCounterID_;


__declspec(dllimport) extern ecs_entity_t EcsCounterIncrement, FLECS_IDEcsCounterIncrementID_;


__declspec(dllimport) extern ecs_entity_t EcsCounterId, FLECS_IDEcsCounterIdID_;


__declspec(dllimport) extern ecs_entity_t EcsGauge, FLECS_IDEcsGaugeID_;


__declspec(dllimport) extern ecs_entity_t EcsMetricInstance, FLECS_IDEcsMetricInstanceID_;


__declspec(dllimport) extern ecs_entity_t FLECS_IDEcsMetricValueID_;


__declspec(dllimport) extern ecs_entity_t FLECS_IDEcsMetricSourceID_;


typedef struct EcsMetricValue {
    double value;
} EcsMetricValue;


typedef struct EcsMetricSource {
    ecs_entity_t entity;
} EcsMetricSource;


typedef struct ecs_metric_desc_t {
    int32_t _canary;       

    
    ecs_entity_t entity;

    

    ecs_entity_t member;

    


    const char *dotmember;

    

    ecs_id_t id;

    



    _Bool targets;

    
    ecs_entity_t kind;

    
    const char *brief;
} ecs_metric_desc_t;








































__declspec(dllimport)
ecs_entity_t ecs_metric_init(
    ecs_world_t *world,
    const ecs_metric_desc_t *desc);























__declspec(dllimport)
void FlecsMetricsImport(
    ecs_world_t *world);











































__declspec(dllimport) extern ecs_entity_t FLECS_IDFlecsAlertsID_;



__declspec(dllimport) extern ecs_entity_t FLECS_IDEcsAlertID_;          
__declspec(dllimport) extern ecs_entity_t FLECS_IDEcsAlertInstanceID_;  
__declspec(dllimport) extern ecs_entity_t FLECS_IDEcsAlertsActiveID_;   
__declspec(dllimport) extern ecs_entity_t FLECS_IDEcsAlertTimeoutID_;   


__declspec(dllimport) extern ecs_entity_t EcsAlertInfo, FLECS_IDEcsAlertInfoID_;            
__declspec(dllimport) extern ecs_entity_t EcsAlertWarning, FLECS_IDEcsAlertWarningID_;         
__declspec(dllimport) extern ecs_entity_t EcsAlertError, FLECS_IDEcsAlertErrorID_;           
__declspec(dllimport) extern ecs_entity_t EcsAlertCritical, FLECS_IDEcsAlertCriticalID_;        


typedef struct EcsAlertInstance {
    char *message; 
} EcsAlertInstance;


typedef struct EcsAlertsActive {
    int32_t info_count;    
    int32_t warning_count; 
    int32_t error_count;   
    ecs_map_t alerts;      
} EcsAlertsActive;







typedef struct ecs_alert_severity_filter_t {
    ecs_entity_t severity; 
    ecs_id_t with;         
    const char *var;       

    int32_t _var_index;    
} ecs_alert_severity_filter_t;


typedef struct ecs_alert_desc_t {
    int32_t _canary;       

    
    ecs_entity_t entity;

    


    ecs_query_desc_t query;

    








    const char *message;

    
    const char *doc_name;

    
    const char *brief;

    

    ecs_entity_t severity;

    



    ecs_alert_severity_filter_t severity_filters[(4)];

    




    float retain_period;

    

    ecs_entity_t member;

    

    ecs_id_t id;

    

    const char *var;
} ecs_alert_desc_t;


























__declspec(dllimport)
ecs_entity_t ecs_alert_init(
    ecs_world_t *world,
    const ecs_alert_desc_t *desc);


















__declspec(dllimport)
int32_t ecs_get_alert_count(
    const ecs_world_t *world,
    ecs_entity_t entity,
    ecs_entity_t alert);










__declspec(dllimport)
ecs_entity_t ecs_get_alert(
    const ecs_world_t *world,
    ecs_entity_t entity,
    ecs_entity_t alert);









__declspec(dllimport)
void FlecsAlertsImport(
    ecs_world_t *world);
















































typedef struct ecs_from_json_desc_t {
    const char *name; 
    const char *expr; 

    

    ecs_entity_t (*lookup_action)(
        ecs_world_t*,
        const char *value,
        void *ctx);
    void *lookup_ctx;              

    

    _Bool strict;
} ecs_from_json_desc_t;












__declspec(dllimport)
const char* ecs_ptr_from_json(
    const ecs_world_t *world,
    ecs_entity_t type,
    void *ptr,
    const char *json,
    const ecs_from_json_desc_t *desc);











__declspec(dllimport)
const char* ecs_entity_from_json(
    ecs_world_t *world,
    ecs_entity_t entity,
    const char *json,
    const ecs_from_json_desc_t *desc);









__declspec(dllimport)
const char* ecs_world_from_json(
    ecs_world_t *world,
    const char *json,
    const ecs_from_json_desc_t *desc);








__declspec(dllimport)
const char* ecs_world_from_json_file(
    ecs_world_t *world,
    const char *filename,
    const ecs_from_json_desc_t *desc);















__declspec(dllimport)
char* ecs_array_to_json(
    const ecs_world_t *world,
    ecs_entity_t type,
    const void *data,
    int32_t count);











__declspec(dllimport)
int ecs_array_to_json_buf(
    const ecs_world_t *world,
    ecs_entity_t type,
    const void *data,
    int32_t count,
    ecs_strbuf_t *buf_out);









__declspec(dllimport)
char* ecs_ptr_to_json(
    const ecs_world_t *world,
    ecs_entity_t type,
    const void *data);










__declspec(dllimport)
int ecs_ptr_to_json_buf(
    const ecs_world_t *world,
    ecs_entity_t type,
    const void *data,
    ecs_strbuf_t *buf_out);











__declspec(dllimport)
char* ecs_type_info_to_json(
    const ecs_world_t *world,
    ecs_entity_t type);









__declspec(dllimport)
int ecs_type_info_to_json_buf(
    const ecs_world_t *world,
    ecs_entity_t type,
    ecs_strbuf_t *buf_out);


typedef struct ecs_entity_to_json_desc_t {
    _Bool serialize_entity_id;  
    _Bool serialize_doc;        
    _Bool serialize_full_paths; 
    _Bool serialize_inherited;  
    _Bool serialize_values;     
    _Bool serialize_builtin;    
    _Bool serialize_type_info;  
    _Bool serialize_alerts;     
    ecs_entity_t serialize_refs; 
    _Bool serialize_matches;    
    
    _Bool (*component_filter)
        (const ecs_world_t *, ecs_entity_t);
} ecs_entity_to_json_desc_t;











































__declspec(dllimport)
char* ecs_entity_to_json(
    ecs_world_t *world,
    ecs_entity_t entity,
    const ecs_entity_to_json_desc_t *desc);










__declspec(dllimport)
int ecs_entity_to_json_buf(
    ecs_world_t *world,
    ecs_entity_t entity,
    ecs_strbuf_t *buf_out,
    const ecs_entity_to_json_desc_t *desc);


typedef struct ecs_iter_to_json_desc_t {
    _Bool serialize_entity_ids;      
    _Bool serialize_values;          
    _Bool serialize_builtin;         
    _Bool serialize_doc;             
    _Bool serialize_full_paths;      
    _Bool serialize_fields;          
    _Bool serialize_inherited;       
    _Bool serialize_table;           
    _Bool serialize_type_info;       
    _Bool serialize_field_info;      
    _Bool serialize_query_info;      
    _Bool serialize_query_plan;      
    _Bool serialize_query_profile;   
    _Bool dont_serialize_results;    
    _Bool serialize_alerts;          
    ecs_entity_t serialize_refs;    
    _Bool serialize_matches;         
    _Bool serialize_parents_before_children; 
    
    
    _Bool (*component_filter)
        (const ecs_world_t *, ecs_entity_t);
    ecs_poly_t *query;            
} ecs_iter_to_json_desc_t;


























































__declspec(dllimport)
char* ecs_iter_to_json(
    ecs_iter_t *iter,
    const ecs_iter_to_json_desc_t *desc);









__declspec(dllimport)
int ecs_iter_to_json_buf(
    ecs_iter_t *iter,
    ecs_strbuf_t *buf_out,
    const ecs_iter_to_json_desc_t *desc);


typedef struct ecs_world_to_json_desc_t {
    _Bool serialize_builtin;    
    _Bool serialize_modules;    
} ecs_world_to_json_desc_t;



















__declspec(dllimport)
char* ecs_world_to_json(
    ecs_world_t *world,
    const ecs_world_to_json_desc_t *desc);









__declspec(dllimport)
int ecs_world_to_json_buf(
    ecs_world_t *world,
    ecs_strbuf_t *buf_out,
    const ecs_world_to_json_desc_t *desc);



















































__declspec(dllimport) extern ecs_entity_t EcsUnitPrefixes; 

__declspec(dllimport) extern ecs_entity_t EcsYocto;  
__declspec(dllimport) extern ecs_entity_t EcsZepto;  
__declspec(dllimport) extern ecs_entity_t EcsAtto;   
__declspec(dllimport) extern ecs_entity_t EcsFemto;  
__declspec(dllimport) extern ecs_entity_t EcsPico;   
__declspec(dllimport) extern ecs_entity_t EcsNano;   
__declspec(dllimport) extern ecs_entity_t EcsMicro;  
__declspec(dllimport) extern ecs_entity_t EcsMilli;  
__declspec(dllimport) extern ecs_entity_t EcsCenti;  
__declspec(dllimport) extern ecs_entity_t EcsDeci;   
__declspec(dllimport) extern ecs_entity_t EcsDeca;   
__declspec(dllimport) extern ecs_entity_t EcsHecto;  
__declspec(dllimport) extern ecs_entity_t EcsKilo;   
__declspec(dllimport) extern ecs_entity_t EcsMega;   
__declspec(dllimport) extern ecs_entity_t EcsGiga;   
__declspec(dllimport) extern ecs_entity_t EcsTera;   
__declspec(dllimport) extern ecs_entity_t EcsPeta;   
__declspec(dllimport) extern ecs_entity_t EcsExa;    
__declspec(dllimport) extern ecs_entity_t EcsZetta;  
__declspec(dllimport) extern ecs_entity_t EcsYotta;  

__declspec(dllimport) extern ecs_entity_t EcsKibi;   
__declspec(dllimport) extern ecs_entity_t EcsMebi;   
__declspec(dllimport) extern ecs_entity_t EcsGibi;   
__declspec(dllimport) extern ecs_entity_t EcsTebi;   
__declspec(dllimport) extern ecs_entity_t EcsPebi;   
__declspec(dllimport) extern ecs_entity_t EcsExbi;   
__declspec(dllimport) extern ecs_entity_t EcsZebi;   
__declspec(dllimport) extern ecs_entity_t EcsYobi;   









__declspec(dllimport) extern ecs_entity_t EcsDuration;         
__declspec(dllimport) extern     ecs_entity_t EcsPicoSeconds;  
__declspec(dllimport) extern     ecs_entity_t EcsNanoSeconds;  
__declspec(dllimport) extern     ecs_entity_t EcsMicroSeconds; 
__declspec(dllimport) extern     ecs_entity_t EcsMilliSeconds; 
__declspec(dllimport) extern     ecs_entity_t EcsSeconds;      
__declspec(dllimport) extern     ecs_entity_t EcsMinutes;      
__declspec(dllimport) extern     ecs_entity_t EcsHours;        
__declspec(dllimport) extern     ecs_entity_t EcsDays;         









__declspec(dllimport) extern ecs_entity_t EcsTime;             
__declspec(dllimport) extern     ecs_entity_t EcsDate;         









__declspec(dllimport) extern ecs_entity_t EcsMass;             
__declspec(dllimport) extern     ecs_entity_t EcsGrams;        
__declspec(dllimport) extern     ecs_entity_t EcsKiloGrams;    









__declspec(dllimport) extern ecs_entity_t EcsElectricCurrent;  
__declspec(dllimport) extern     ecs_entity_t EcsAmpere;       









__declspec(dllimport) extern ecs_entity_t EcsAmount;           
__declspec(dllimport) extern     ecs_entity_t EcsMole;         









__declspec(dllimport) extern ecs_entity_t EcsLuminousIntensity; 
__declspec(dllimport) extern     ecs_entity_t EcsCandela;       









__declspec(dllimport) extern ecs_entity_t EcsForce;            
__declspec(dllimport) extern     ecs_entity_t EcsNewton;       









__declspec(dllimport) extern ecs_entity_t EcsLength;              
__declspec(dllimport) extern     ecs_entity_t EcsMeters;          
__declspec(dllimport) extern         ecs_entity_t EcsPicoMeters;  
__declspec(dllimport) extern         ecs_entity_t EcsNanoMeters;  
__declspec(dllimport) extern         ecs_entity_t EcsMicroMeters; 
__declspec(dllimport) extern         ecs_entity_t EcsMilliMeters; 
__declspec(dllimport) extern         ecs_entity_t EcsCentiMeters; 
__declspec(dllimport) extern         ecs_entity_t EcsKiloMeters;  
__declspec(dllimport) extern     ecs_entity_t EcsMiles;           
__declspec(dllimport) extern     ecs_entity_t EcsPixels;          









__declspec(dllimport) extern ecs_entity_t EcsPressure;          
__declspec(dllimport) extern     ecs_entity_t EcsPascal;        
__declspec(dllimport) extern     ecs_entity_t EcsBar;           









__declspec(dllimport) extern ecs_entity_t EcsSpeed;                   
__declspec(dllimport) extern     ecs_entity_t EcsMetersPerSecond;     
__declspec(dllimport) extern     ecs_entity_t EcsKiloMetersPerSecond; 
__declspec(dllimport) extern     ecs_entity_t EcsKiloMetersPerHour;   
__declspec(dllimport) extern     ecs_entity_t EcsMilesPerHour;        









__declspec(dllimport) extern ecs_entity_t EcsTemperature;       
__declspec(dllimport) extern     ecs_entity_t EcsKelvin;        
__declspec(dllimport) extern     ecs_entity_t EcsCelsius;       
__declspec(dllimport) extern     ecs_entity_t EcsFahrenheit;    









__declspec(dllimport) extern ecs_entity_t EcsData;               
__declspec(dllimport) extern     ecs_entity_t EcsBits;           
__declspec(dllimport) extern         ecs_entity_t EcsKiloBits;   
__declspec(dllimport) extern         ecs_entity_t EcsMegaBits;   
__declspec(dllimport) extern         ecs_entity_t EcsGigaBits;   
__declspec(dllimport) extern     ecs_entity_t EcsBytes;          
__declspec(dllimport) extern         ecs_entity_t EcsKiloBytes;  
__declspec(dllimport) extern         ecs_entity_t EcsMegaBytes;  
__declspec(dllimport) extern         ecs_entity_t EcsGigaBytes;  
__declspec(dllimport) extern         ecs_entity_t EcsKibiBytes;  
__declspec(dllimport) extern         ecs_entity_t EcsMebiBytes;  
__declspec(dllimport) extern         ecs_entity_t EcsGibiBytes;  









__declspec(dllimport) extern ecs_entity_t EcsDataRate;               
__declspec(dllimport) extern     ecs_entity_t EcsBitsPerSecond;      
__declspec(dllimport) extern     ecs_entity_t EcsKiloBitsPerSecond;  
__declspec(dllimport) extern     ecs_entity_t EcsMegaBitsPerSecond;  
__declspec(dllimport) extern     ecs_entity_t EcsGigaBitsPerSecond;  
__declspec(dllimport) extern     ecs_entity_t EcsBytesPerSecond;     
__declspec(dllimport) extern     ecs_entity_t EcsKiloBytesPerSecond; 
__declspec(dllimport) extern     ecs_entity_t EcsMegaBytesPerSecond; 
__declspec(dllimport) extern     ecs_entity_t EcsGigaBytesPerSecond; 









__declspec(dllimport) extern ecs_entity_t EcsAngle;            
__declspec(dllimport) extern     ecs_entity_t EcsRadians;      
__declspec(dllimport) extern     ecs_entity_t EcsDegrees;      









__declspec(dllimport) extern ecs_entity_t EcsFrequency;        
__declspec(dllimport) extern     ecs_entity_t EcsHertz;        
__declspec(dllimport) extern     ecs_entity_t EcsKiloHertz;    
__declspec(dllimport) extern     ecs_entity_t EcsMegaHertz;    
__declspec(dllimport) extern     ecs_entity_t EcsGigaHertz;    









__declspec(dllimport) extern ecs_entity_t EcsUri;              
__declspec(dllimport) extern     ecs_entity_t EcsUriHyperlink; 
__declspec(dllimport) extern     ecs_entity_t EcsUriImage;     
__declspec(dllimport) extern     ecs_entity_t EcsUriFile;      









__declspec(dllimport) extern ecs_entity_t EcsColor;            
__declspec(dllimport) extern     ecs_entity_t EcsColorRgb;     
__declspec(dllimport) extern     ecs_entity_t EcsColorHsl;     
__declspec(dllimport) extern     ecs_entity_t EcsColorCss;     



__declspec(dllimport) extern ecs_entity_t EcsAcceleration;     
__declspec(dllimport) extern ecs_entity_t EcsPercentage;       
__declspec(dllimport) extern ecs_entity_t EcsBel;              
__declspec(dllimport) extern ecs_entity_t EcsDeciBel;          













__declspec(dllimport)
void FlecsUnitsImport(
    ecs_world_t *world);











































































































































































__declspec(dllimport)
extern ecs_entity_t FLECS_IDEcsScriptID_;

__declspec(dllimport)
extern ecs_entity_t EcsScriptTemplate, FLECS_IDEcsScriptTemplateID_;

__declspec(dllimport)
extern ecs_entity_t FLECS_IDEcsScriptConstVarID_;

__declspec(dllimport)
extern ecs_entity_t FLECS_IDEcsScriptFunctionID_;

__declspec(dllimport)
extern ecs_entity_t FLECS_IDEcsScriptMethodID_;

__declspec(dllimport)
extern ecs_entity_t EcsScriptVectorType, FLECS_IDEcsScriptVectorTypeID_;


typedef struct ecs_script_template_t ecs_script_template_t;


typedef struct ecs_script_var_t {
    const char *name;                    
    ecs_value_t value;                   
    const ecs_type_info_t *type_info;    
    int32_t sp;                          
    _Bool is_const;                       
} ecs_script_var_t;


typedef struct ecs_script_vars_t {
    struct ecs_script_vars_t *parent;    
    int32_t sp;                          

    ecs_hashmap_t var_index;             
    ecs_vec_t vars;                      

    const ecs_world_t *world;            
    struct ecs_stack_t *stack;           
    ecs_stack_cursor_t *cursor;          
    ecs_allocator_t *allocator;          
} ecs_script_vars_t;


typedef struct ecs_script_t {
    ecs_world_t *world;    
    const char *name;      
    const char *code;      
} ecs_script_t;


typedef struct ecs_script_runtime_t ecs_script_runtime_t;




typedef struct EcsScript {
    char *filename;                     
    char *code;                         
    char *error;                        
    ecs_script_t *script;               
    ecs_script_template_t *template_;   
    ecs_vec_t observers;                
} EcsScript;


typedef struct ecs_function_ctx_t {
    ecs_world_t *world;       
    ecs_entity_t function;    
    void *ctx;                
} ecs_function_ctx_t;


typedef void(*ecs_function_callback_t)(
    const ecs_function_ctx_t *ctx,
    int32_t argc,
    const ecs_value_t *argv,
    ecs_value_t *result);


typedef void(*ecs_vector_function_callback_t)(
    const ecs_function_ctx_t *ctx,
    int32_t argc,
    const ecs_value_t *argv,
    ecs_value_t *result,
    int32_t elem_count);


typedef struct ecs_script_parameter_t {
    const char *name;       
    ecs_entity_t type;      
} ecs_script_parameter_t;




typedef struct EcsScriptConstVar {
    ecs_value_t value;
    const ecs_type_info_t *type_info;
} EcsScriptConstVar;

struct ecs_script_function_t {
    ecs_entity_t return_type;
    ecs_vec_t params; 
    ecs_function_callback_t callback;
    ecs_vector_function_callback_t vector_callbacks[(18)];
    void *ctx;
    void *binding_ctx;
    ecs_ctx_free_t binding_ctx_free;
};




typedef struct ecs_script_function_t EcsScriptFunction;






typedef struct ecs_script_function_t EcsScriptMethod;




typedef struct ecs_script_eval_desc_t {
    ecs_script_vars_t *vars;       
    ecs_script_runtime_t *runtime; 
} ecs_script_eval_desc_t;


typedef struct ecs_script_eval_result_t {
    char *error;       
    int32_t line;      
    int32_t column;    
} ecs_script_eval_result_t;




















__declspec(dllimport)
ecs_script_t* ecs_script_parse(
    ecs_world_t *world,
    const char *name,
    const char *code,
    const ecs_script_eval_desc_t *desc,
    ecs_script_eval_result_t *result);

















__declspec(dllimport)
int ecs_script_eval(
    const ecs_script_t *script,
    const ecs_script_eval_desc_t *desc,
    ecs_script_eval_result_t *result);










__declspec(dllimport)
void ecs_script_free(
    ecs_script_t *script);

















__declspec(dllimport)
int ecs_script_run(
    ecs_world_t *world,
    const char *name,
    const char *code,
    ecs_script_eval_result_t *result);










__declspec(dllimport)
int ecs_script_run_file(
    ecs_world_t *world,
    const char *filename);














__declspec(dllimport)
ecs_script_runtime_t* ecs_script_runtime_new(void);






__declspec(dllimport)
void ecs_script_runtime_free(
    ecs_script_runtime_t *runtime);










__declspec(dllimport)
int ecs_script_ast_to_buf(
    ecs_script_t *script,
    ecs_strbuf_t *buf,
    _Bool colors);









__declspec(dllimport)
char* ecs_script_ast_to_str(
    ecs_script_t *script,
    _Bool colors);




typedef struct ecs_script_desc_t {
    ecs_entity_t entity;   
    const char *filename;  
    const char *code;      
} ecs_script_desc_t;












__declspec(dllimport)
ecs_entity_t ecs_script_init(
    ecs_world_t *world,
    const ecs_script_desc_t *desc);












__declspec(dllimport)
int ecs_script_update(
    ecs_world_t *world,
    ecs_entity_t script,
    ecs_entity_t instance,
    const char *code);







__declspec(dllimport)
void ecs_script_clear(
    ecs_world_t *world,
    ecs_entity_t script,
    ecs_entity_t instance);




















__declspec(dllimport)
ecs_script_vars_t* ecs_script_vars_init(
    ecs_world_t *world);







__declspec(dllimport)
void ecs_script_vars_fini(
    ecs_script_vars_t *vars);












__declspec(dllimport)
ecs_script_vars_t* ecs_script_vars_push(
    ecs_script_vars_t *parent);









__declspec(dllimport)
ecs_script_vars_t* ecs_script_vars_pop(
    ecs_script_vars_t *vars);













__declspec(dllimport)
ecs_script_var_t* ecs_script_vars_declare(
    ecs_script_vars_t *vars,
    const char *name);
















__declspec(dllimport)
ecs_script_var_t* ecs_script_vars_define_id(
    ecs_script_vars_t *vars,
    const char *name,
    ecs_entity_t type);













__declspec(dllimport)
ecs_script_var_t* ecs_script_vars_lookup(
    const ecs_script_vars_t *vars,
    const char *name);













__declspec(dllimport)
ecs_script_var_t* ecs_script_vars_from_sp(
    const ecs_script_vars_t *vars,
    int32_t sp);






__declspec(dllimport)
void ecs_script_vars_print(
    const ecs_script_vars_t *vars);









__declspec(dllimport)
void ecs_script_vars_set_size(
    ecs_script_vars_t *vars,
    int32_t count);

































__declspec(dllimport)
void ecs_script_vars_from_iter(
    const ecs_iter_t *it,
    ecs_script_vars_t *vars,
    int offset);




typedef struct ecs_expr_eval_desc_t {
    const char *name;                
    const char *expr;                
    const ecs_script_vars_t *vars;   
    ecs_entity_t type;               
    ecs_entity_t (*lookup_action)(   
        const ecs_world_t*,
        const char *value,
        void *ctx);
    void *lookup_ctx;                

    
    _Bool disable_folding;

    


    _Bool disable_dynamic_variable_binding;

    

    _Bool allow_unresolved_identifiers;

    ecs_script_runtime_t *runtime;   

    void *script_visitor;            

    _Bool (*unresolved_identifier_action)( 
        const ecs_world_t*,
        const char *value,
        void *ctx);
} ecs_expr_eval_desc_t;















__declspec(dllimport)
const char* ecs_expr_run(
    ecs_world_t *world,
    const char *ptr,
    ecs_value_t *value,
    const ecs_expr_eval_desc_t *desc);










__declspec(dllimport)
ecs_script_t* ecs_expr_parse(
    ecs_world_t *world,
    const char *expr,
    const ecs_expr_eval_desc_t *desc);















__declspec(dllimport)
int ecs_expr_eval(
    const ecs_script_t *script,
    ecs_value_t *value,
    const ecs_expr_eval_desc_t *desc);














__declspec(dllimport)
char* ecs_script_string_interpolate(
    ecs_world_t *world,
    const char *str,
    const ecs_script_vars_t *vars);




typedef struct ecs_const_var_desc_t {
    
    const char *name;

    
    ecs_entity_t parent;

    
    ecs_entity_t type;

    

    void *value;
} ecs_const_var_desc_t;







__declspec(dllimport)
ecs_entity_t ecs_const_var_init(
    ecs_world_t *world,
    ecs_const_var_desc_t *desc);












__declspec(dllimport)
ecs_value_t ecs_const_var_get(
    const ecs_world_t *world,
    ecs_entity_t var);



















__declspec(dllimport)
void* ecs_const_var_get_w_type(
    const ecs_world_t *world,
    const char *name,
    ecs_entity_t type,
    ecs_size_t size,
    void *out);



























__declspec(dllimport)
void ecs_const_var_modified(
    ecs_world_t *world,
    ecs_entity_t var);




typedef struct ecs_vector_fn_callbacks_t {
    ecs_vector_function_callback_t i8;   
    ecs_vector_function_callback_t i32;  
} ecs_vector_fn_callbacks_t;


typedef struct ecs_function_desc_t {
    
    const char *name;
    
    

    ecs_entity_t parent;

    
    ecs_script_parameter_t params[(16)];

    
    ecs_entity_t return_type;

    
    ecs_function_callback_t callback;

    














































    ecs_vector_function_callback_t vector_callbacks[(18)];

    
    void *ctx;
} ecs_function_desc_t;








__declspec(dllimport)
ecs_entity_t ecs_function_init(
    ecs_world_t *world,
    const ecs_function_desc_t *desc);




__declspec(dllimport)
int ecs_function_call(
    ecs_world_t *world,
    ecs_entity_t function,
    int32_t argc,
    const ecs_value_t *argv,
    ecs_value_t *result);













__declspec(dllimport)
ecs_entity_t ecs_method_init(
    ecs_world_t *world,
    const ecs_function_desc_t *desc);




__declspec(dllimport)
int ecs_method_call(
    ecs_world_t *world,
    ecs_entity_t method,
    const ecs_value_t *instance,
    int32_t argc,
    const ecs_value_t *argv,
    ecs_value_t *result);












__declspec(dllimport)
char* ecs_ptr_to_expr(
    const ecs_world_t *world,
    ecs_entity_t type,
    const void *data);










__declspec(dllimport)
int ecs_ptr_to_expr_buf(
    const ecs_world_t *world,
    ecs_entity_t type,
    const void *data,
    ecs_strbuf_t *buf);












__declspec(dllimport)
char* ecs_ptr_to_str(
    const ecs_world_t *world,
    ecs_entity_t type,
    const void *data);










__declspec(dllimport)
int ecs_ptr_to_str_buf(
    const ecs_world_t *world,
    ecs_entity_t type,
    const void *data,
    ecs_strbuf_t *buf);

typedef struct ecs_expr_node_t ecs_expr_node_t; 









__declspec(dllimport)
void FlecsScriptImport(
    ecs_world_t *world);







































__declspec(dllimport) extern const ecs_entity_t FLECS_IDEcsDocDescriptionID_; 




__declspec(dllimport) extern const ecs_entity_t EcsDocUuid;




__declspec(dllimport) extern const ecs_entity_t EcsDocBrief;




__declspec(dllimport) extern const ecs_entity_t EcsDocDetail;




__declspec(dllimport) extern const ecs_entity_t EcsDocLink;




__declspec(dllimport) extern const ecs_entity_t EcsDocColor;









typedef struct EcsDocDescription {
    char *value;           
} EcsDocDescription;












__declspec(dllimport)
void ecs_doc_set_uuid(
    ecs_world_t *world,
    ecs_entity_t entity,
    const char *uuid);













__declspec(dllimport)
void ecs_doc_set_name(
    ecs_world_t *world,
    ecs_entity_t entity,
    const char *name);











__declspec(dllimport)
void ecs_doc_set_brief(
    ecs_world_t *world,
    ecs_entity_t entity,
    const char *description);











__declspec(dllimport)
void ecs_doc_set_detail(
    ecs_world_t *world,
    ecs_entity_t entity,
    const char *description);











__declspec(dllimport)
void ecs_doc_set_link(
    ecs_world_t *world,
    ecs_entity_t entity,
    const char *link);












__declspec(dllimport)
void ecs_doc_set_color(
    ecs_world_t *world,
    ecs_entity_t entity,
    const char *color);










__declspec(dllimport)
const char* ecs_doc_get_uuid(
    const ecs_world_t *world,
    ecs_entity_t entity);

























__declspec(dllimport)
const char* ecs_doc_get_name(
    const ecs_world_t *world,
    ecs_entity_t entity);











__declspec(dllimport)
const char* ecs_doc_get_brief(
    const ecs_world_t *world,
    ecs_entity_t entity);











__declspec(dllimport)
const char* ecs_doc_get_detail(
    const ecs_world_t *world,
    ecs_entity_t entity);











__declspec(dllimport)
const char* ecs_doc_get_link(
    const ecs_world_t *world,
    ecs_entity_t entity);











__declspec(dllimport)
const char* ecs_doc_get_color(
    const ecs_world_t *world,
    ecs_entity_t entity);









__declspec(dllimport)
void FlecsDocImport(
    ecs_world_t *world);
























































typedef _Bool ecs_bool_t;                                        
typedef char ecs_char_t;                                        
typedef unsigned char ecs_byte_t;                               
typedef uint8_t ecs_u8_t;                                       
typedef uint16_t ecs_u16_t;                                     
typedef uint32_t ecs_u32_t;                                     
typedef uint64_t ecs_u64_t;                                     
typedef uintptr_t ecs_uptr_t;                                   
typedef int8_t ecs_i8_t;                                        
typedef int16_t ecs_i16_t;                                      
typedef int32_t ecs_i32_t;                                      
typedef int64_t ecs_i64_t;                                      
typedef intptr_t ecs_iptr_t;                                    
typedef float ecs_f32_t;                                        
typedef double ecs_f64_t;                                       
typedef char* ecs_string_t;                                     


__declspec(dllimport) extern const ecs_entity_t FLECS_IDEcsTypeID_;            
__declspec(dllimport) extern const ecs_entity_t FLECS_IDEcsTypeSerializerID_;  
__declspec(dllimport) extern const ecs_entity_t FLECS_IDEcsPrimitiveID_;       
__declspec(dllimport) extern const ecs_entity_t FLECS_IDEcsEnumID_;            
__declspec(dllimport) extern const ecs_entity_t FLECS_IDEcsBitmaskID_;         
__declspec(dllimport) extern const ecs_entity_t FLECS_IDEcsConstantsID_;       
__declspec(dllimport) extern const ecs_entity_t FLECS_IDEcsMemberID_;          
__declspec(dllimport) extern const ecs_entity_t FLECS_IDEcsMemberRangesID_;    
__declspec(dllimport) extern const ecs_entity_t FLECS_IDEcsStructID_;          
__declspec(dllimport) extern const ecs_entity_t FLECS_IDEcsArrayID_;           
__declspec(dllimport) extern const ecs_entity_t FLECS_IDEcsVectorID_;          
__declspec(dllimport) extern const ecs_entity_t FLECS_IDEcsMapID_;             
__declspec(dllimport) extern const ecs_entity_t FLECS_IDEcsOpaqueID_;          
__declspec(dllimport) extern const ecs_entity_t FLECS_IDEcsUnitID_;            
__declspec(dllimport) extern const ecs_entity_t FLECS_IDEcsUnitPrefixID_;      
__declspec(dllimport) extern const ecs_entity_t EcsQuantity;                



__declspec(dllimport) extern const ecs_entity_t FLECS_IDecs_bool_tID_;         
__declspec(dllimport) extern const ecs_entity_t FLECS_IDecs_char_tID_;         
__declspec(dllimport) extern const ecs_entity_t FLECS_IDecs_byte_tID_;         
__declspec(dllimport) extern const ecs_entity_t FLECS_IDecs_u8_tID_;           
__declspec(dllimport) extern const ecs_entity_t FLECS_IDecs_u16_tID_;          
__declspec(dllimport) extern const ecs_entity_t FLECS_IDecs_u32_tID_;          
__declspec(dllimport) extern const ecs_entity_t FLECS_IDecs_u64_tID_;          
__declspec(dllimport) extern const ecs_entity_t FLECS_IDecs_uptr_tID_;         
__declspec(dllimport) extern const ecs_entity_t FLECS_IDecs_i8_tID_;           
__declspec(dllimport) extern const ecs_entity_t FLECS_IDecs_i16_tID_;          
__declspec(dllimport) extern const ecs_entity_t FLECS_IDecs_i32_tID_;          
__declspec(dllimport) extern const ecs_entity_t FLECS_IDecs_i64_tID_;          
__declspec(dllimport) extern const ecs_entity_t FLECS_IDecs_iptr_tID_;         
__declspec(dllimport) extern const ecs_entity_t FLECS_IDecs_f32_tID_;          
__declspec(dllimport) extern const ecs_entity_t FLECS_IDecs_f64_tID_;          
__declspec(dllimport) extern const ecs_entity_t FLECS_IDecs_string_tID_;       
__declspec(dllimport) extern const ecs_entity_t FLECS_IDecs_entity_tID_;       
__declspec(dllimport) extern const ecs_entity_t FLECS_IDecs_id_tID_;           
__declspec(dllimport) extern const ecs_entity_t FLECS_IDecs_value_tID_;      


typedef enum ecs_type_kind_t {
    EcsPrimitiveType,
    EcsBitmaskType,
    EcsEnumType,
    EcsStructType,
    EcsArrayType,
    EcsVectorType,
    EcsOpaqueType,
    EcsMapType,
    EcsValueType,
    EcsTypeKindLast = EcsValueType
} ecs_type_kind_t;


typedef struct EcsType {
    ecs_type_kind_t kind;  
    _Bool existing;         
    _Bool partial;          
} EcsType;


typedef enum ecs_primitive_kind_t {
    EcsBool = 1,
    EcsChar,
    EcsByte,
    EcsU8,
    EcsU16,
    EcsU32,
    EcsU64,
    EcsI8,
    EcsI16,
    EcsI32,
    EcsI64,
    EcsF32,
    EcsF64,
    EcsUPtr,
    EcsIPtr,
    EcsString,
    EcsEntity,
    EcsId,
    EcsPrimitiveKindLast = EcsId
} ecs_primitive_kind_t;


typedef struct EcsPrimitive {
    ecs_primitive_kind_t kind;                     
} EcsPrimitive;


typedef struct EcsMember {
    ecs_entity_t type;                             
    int32_t count;                                 
    ecs_entity_t unit;                             
    int32_t offset;                                
    _Bool use_offset;                               
} EcsMember;


typedef struct ecs_member_value_range_t {
    double min;                                    
    double max;                                    
} ecs_member_value_range_t;


typedef struct EcsMemberRanges {
    ecs_member_value_range_t value;                
    ecs_member_value_range_t warning;              
    ecs_member_value_range_t error;                
} EcsMemberRanges;


typedef struct ecs_member_t {
    
    const char *name;

    
    ecs_entity_t type;

    

    int32_t count;

    
    int32_t offset;

    

    ecs_entity_t unit;

    


    _Bool use_offset;

    


    ecs_member_value_range_t range;

    

    ecs_member_value_range_t error_range;

    

    ecs_member_value_range_t warning_range;

    
    ecs_size_t size;

    
    ecs_entity_t member;
} ecs_member_t;


typedef struct EcsStruct {
    
    ecs_vec_t members; 
} EcsStruct;


typedef struct ecs_enum_constant_t {
    
    const char *name;

    
    int64_t value;

    
    uint64_t value_unsigned;

    
    ecs_entity_t constant;
} ecs_enum_constant_t;


typedef struct EcsEnum {
    ecs_entity_t underlying_type;  
} EcsEnum;


typedef struct ecs_bitmask_constant_t {
    
    const char *name;

    
    ecs_flags64_t value;

    
    int64_t _unused;

    
    ecs_entity_t constant;
} ecs_bitmask_constant_t;


typedef struct EcsBitmask {
    int32_t dummy_;                
} EcsBitmask;


typedef struct EcsConstants {
    
    ecs_map_t *constants; 

    
    ecs_vec_t ordered_constants; 
} EcsConstants;


typedef struct EcsArray {
    ecs_entity_t type; 
    int32_t count;     
} EcsArray;


typedef struct EcsVector {
    ecs_entity_t type; 
} EcsVector;


typedef struct EcsMap {
    ecs_entity_t key_type; 
    ecs_entity_t type;     
} EcsMap;






typedef struct ecs_serializer_t {
    
    int (*value)(
        const struct ecs_serializer_t *ser, 
        ecs_entity_t type,                  
        const void *value);                 

    
    int (*member)(
        const struct ecs_serializer_t *ser, 
        const char *member);                

    const ecs_world_t *world;               
    void *ctx;                              
} ecs_serializer_t;




































typedef int (*ecs_meta_serialize_t)(
    const ecs_serializer_t *ser,
    const void *src);                  


typedef int (*ecs_meta_serialize_member_t)(
    const ecs_serializer_t *ser,
    const void *src,                   
    const char* name);                 


typedef int (*ecs_meta_serialize_element_t)(
    const ecs_serializer_t *ser,
    const void *src,                   
    size_t elem);                      





typedef struct EcsOpaque {
    ecs_entity_t as_type;              
    ecs_meta_serialize_t serialize;    
    ecs_meta_serialize_member_t serialize_member; 
    ecs_meta_serialize_element_t serialize_element; 

    





    
    void (*assign_bool)(
        void *dst,
        _Bool value);

    
    void (*assign_char)(
        void *dst,
        char value);

    
    void (*assign_int)(
        void *dst,
        int64_t value);

    
    void (*assign_uint)(
        void *dst,
        uint64_t value);

    
    void (*assign_float)(
        void *dst,
        double value);

    
    void (*assign_string)(
        void *dst,
        const char *value);

    
    void (*assign_entity)(
        void *dst,
        ecs_world_t *world,
        ecs_entity_t entity);

    
    void (*assign_id)(
        void *dst,
        ecs_world_t *world,
        ecs_id_t id);

    
    void (*assign_null)(
        void *dst);

    
    void (*clear)(
        void *dst);

    
    void* (*ensure_element)(
        void *dst,
        size_t elem);

    
    void* (*ensure_member)(
        void *dst,
        const char *member);

    
    size_t (*count)(
        const void *dst);

    
    void (*resize)(
        void *dst,
        size_t count);
} EcsOpaque;










typedef struct ecs_unit_translation_t {
    int32_t factor; 
    int32_t power;  
} ecs_unit_translation_t;


typedef struct EcsUnit {
    char *symbol;                                  
    ecs_entity_t prefix;                           
    ecs_entity_t base;                             
    ecs_entity_t over;                             
    ecs_unit_translation_t translation;            
} EcsUnit;


typedef struct EcsUnitPrefix {
    char *symbol;                                 
    ecs_unit_translation_t translation;           
} EcsUnitPrefix;








typedef enum ecs_meta_op_kind_t {
    EcsOpPushStruct,   
    EcsOpPushArray,    
    EcsOpPushVector,   
    EcsOpPushMap,      
    EcsOpPushValue,  
    EcsOpPop,          

    EcsOpOpaqueStruct, 
    EcsOpOpaqueArray,  
    EcsOpOpaqueVector, 
    EcsOpForward,      

    EcsOpScope,        

    EcsOpOpaqueValue,  
    EcsOpEnum,
    EcsOpBitmask,

    EcsOpPrimitive,    

    EcsOpBool,
    EcsOpChar,
    EcsOpByte,
    EcsOpU8,
    EcsOpU16,
    EcsOpU32,
    EcsOpU64,
    EcsOpI8,
    EcsOpI16,
    EcsOpI32,
    EcsOpI64,
    EcsOpF32,
    EcsOpF64,
    EcsOpUPtr,
    EcsOpIPtr,
    EcsOpString,
    EcsOpEntity,
    EcsOpId,
    EcsMetaTypeOpKindLast = EcsOpId
} ecs_meta_op_kind_t;


typedef struct ecs_meta_op_t {
    ecs_meta_op_kind_t kind;                       
    ecs_meta_op_kind_t underlying_kind;            
    ecs_size_t offset;                             
    const char *name;                              
    ecs_size_t elem_size;                          
    int16_t op_count;                              
    int16_t member_index;                          
    ecs_entity_t type;                             
    const ecs_type_info_t *type_info;              
    union {
        ecs_hashmap_t *members;                    
        ecs_map_t *constants;                      
        ecs_meta_serialize_t opaque;               
    } is;
} ecs_meta_op_t;



typedef struct EcsTypeSerializer {
    ecs_type_kind_t kind;         
    ecs_vec_t ops;                
} EcsTypeSerializer;









typedef struct ecs_meta_scope_t {
    ecs_entity_t type;                             
    ecs_meta_op_t *ops;                            
    int16_t ops_count;                             
    int16_t ops_cur;                               
    int16_t prev_depth;                            
    void *ptr;                                     
    const EcsOpaque *opaque;                       
    ecs_hashmap_t *members;                        
    _Bool is_collection;                            
    _Bool is_map;                                   
    _Bool is_value;                               
    _Bool is_empty_scope;                           
    _Bool is_moved_scope;                           
    int32_t elem, elem_count;                      
} ecs_meta_scope_t;


typedef struct ecs_meta_cursor_t {
    const ecs_world_t *world;                      
    ecs_meta_scope_t scope[(32)]; 
    int16_t depth;                                 
    _Bool valid;                                    
    _Bool is_primitive_scope;                       

    
    ecs_entity_t (*lookup_action)(ecs_world_t*, const char*, void*);
    void *lookup_ctx;                              
} ecs_meta_cursor_t;







__declspec(dllimport)
char* ecs_meta_serializer_to_str(
    ecs_world_t *world,
    ecs_entity_t type);















__declspec(dllimport)
ecs_meta_cursor_t ecs_meta_cursor(
    const ecs_world_t *world,
    ecs_entity_t type,
    void *ptr);






__declspec(dllimport)
void* ecs_meta_get_ptr(
    ecs_meta_cursor_t *cursor);






__declspec(dllimport)
int ecs_meta_next(
    ecs_meta_cursor_t *cursor);






__declspec(dllimport)
int ecs_meta_elem(
    ecs_meta_cursor_t *cursor,
    int32_t elem);







__declspec(dllimport)
int ecs_meta_member(
    ecs_meta_cursor_t *cursor,
    const char *name);







__declspec(dllimport)
int ecs_meta_key(
    ecs_meta_cursor_t *cursor,
    const ecs_value_t *key);








__declspec(dllimport)
int ecs_meta_try_member(
    ecs_meta_cursor_t *cursor,
    const char *name);









__declspec(dllimport)
int ecs_meta_dotmember(
    ecs_meta_cursor_t *cursor,
    const char *name);








__declspec(dllimport)
int ecs_meta_try_dotmember(
    ecs_meta_cursor_t *cursor,
    const char *name);






__declspec(dllimport)
int ecs_meta_push(
    ecs_meta_cursor_t *cursor);






__declspec(dllimport)
int ecs_meta_pop(
    ecs_meta_cursor_t *cursor);






__declspec(dllimport)
_Bool ecs_meta_is_collection(
    const ecs_meta_cursor_t *cursor);









__declspec(dllimport)
_Bool ecs_meta_is_map(
    const ecs_meta_cursor_t *cursor);






__declspec(dllimport)
ecs_entity_t ecs_meta_get_type(
    const ecs_meta_cursor_t *cursor);






__declspec(dllimport)
ecs_entity_t ecs_meta_get_unit(
    const ecs_meta_cursor_t *cursor);






__declspec(dllimport)
const char* ecs_meta_get_member(
    const ecs_meta_cursor_t *cursor);






__declspec(dllimport)
ecs_entity_t ecs_meta_get_member_id(
    const ecs_meta_cursor_t *cursor);











__declspec(dllimport)
int ecs_meta_set_bool(
    ecs_meta_cursor_t *cursor,
    _Bool value);







__declspec(dllimport)
int ecs_meta_set_char(
    ecs_meta_cursor_t *cursor,
    char value);







__declspec(dllimport)
int ecs_meta_set_int(
    ecs_meta_cursor_t *cursor,
    int64_t value);







__declspec(dllimport)
int ecs_meta_set_uint(
    ecs_meta_cursor_t *cursor,
    uint64_t value);







__declspec(dllimport)
int ecs_meta_set_float(
    ecs_meta_cursor_t *cursor,
    double value);







__declspec(dllimport)
int ecs_meta_set_string(
    ecs_meta_cursor_t *cursor,
    const char *value);







__declspec(dllimport)
int ecs_meta_set_string_literal(
    ecs_meta_cursor_t *cursor,
    const char *value);







__declspec(dllimport)
int ecs_meta_set_entity(
    ecs_meta_cursor_t *cursor,
    ecs_entity_t value);







__declspec(dllimport)
int ecs_meta_set_id(
    ecs_meta_cursor_t *cursor,
    ecs_id_t value);






__declspec(dllimport)
int ecs_meta_set_null(
    ecs_meta_cursor_t *cursor);









__declspec(dllimport)
int ecs_meta_set_value(
    ecs_meta_cursor_t *cursor,
    const ecs_value_t *value);








__declspec(dllimport)
_Bool ecs_meta_get_bool(
    const ecs_meta_cursor_t *cursor);






__declspec(dllimport)
char ecs_meta_get_char(
    const ecs_meta_cursor_t *cursor);






__declspec(dllimport)
int64_t ecs_meta_get_int(
    const ecs_meta_cursor_t *cursor);






__declspec(dllimport)
uint64_t ecs_meta_get_uint(
    const ecs_meta_cursor_t *cursor);






__declspec(dllimport)
double ecs_meta_get_float(
    const ecs_meta_cursor_t *cursor);








__declspec(dllimport)
const char* ecs_meta_get_string(
    const ecs_meta_cursor_t *cursor);







__declspec(dllimport)
ecs_entity_t ecs_meta_get_entity(
    const ecs_meta_cursor_t *cursor);







__declspec(dllimport)
ecs_id_t ecs_meta_get_id(
    const ecs_meta_cursor_t *cursor);







__declspec(dllimport)
double ecs_meta_ptr_to_float(
    ecs_primitive_kind_t type_kind,
    const void *ptr);










__declspec(dllimport)
ecs_size_t ecs_meta_op_get_elem_count(
    const ecs_meta_op_t *op,
    const void *ptr);
















__declspec(dllimport)
ecs_entity_t ecs_constant_to_entity(
    const ecs_world_t *world,
    ecs_entity_t type,
    int64_t value);











__declspec(dllimport)
int ecs_ptr_init(
    const ecs_world_t *world,
    ecs_entity_t type,
    void *ptr);








__declspec(dllimport)
int ecs_ptr_init_w_type_info(
    const ecs_world_t *world,
    const ecs_type_info_t *ti,
    void *ptr);







__declspec(dllimport)
void* ecs_ptr_new(
    ecs_world_t *world,
    ecs_entity_t type);







void* ecs_ptr_new_w_type_info(
    ecs_world_t *world,
    const ecs_type_info_t *ti);








int ecs_ptr_fini_w_type_info(
    const ecs_world_t *world,
    const ecs_type_info_t *ti,
    void *ptr);








__declspec(dllimport)
int ecs_ptr_fini(
    const ecs_world_t *world,
    ecs_entity_t type,
    void* ptr);








__declspec(dllimport)
int ecs_ptr_free_w_type_info(
    ecs_world_t *world,
    const ecs_type_info_t *ti,
    void* ptr);








__declspec(dllimport)
int ecs_ptr_free(
    ecs_world_t *world,
    ecs_entity_t type,
    void* ptr);









__declspec(dllimport)
int ecs_ptr_copy_w_type_info(
    const ecs_world_t *world,
    const ecs_type_info_t *ti,
    void* dst,
    const void *src);









__declspec(dllimport)
int ecs_ptr_copy(
    const ecs_world_t *world,
    ecs_entity_t type,
    void* dst,
    const void *src);









__declspec(dllimport)
int ecs_ptr_move_w_type_info(
    const ecs_world_t *world,
    const ecs_type_info_t *ti,
    void* dst,
    void *src);









__declspec(dllimport)
int ecs_ptr_move(
    const ecs_world_t *world,
    ecs_entity_t type,
    void* dst,
    void *src);









__declspec(dllimport)
int ecs_ptr_move_ctor_w_type_info(
    const ecs_world_t *world,
    const ecs_type_info_t *ti,
    void* dst,
    void *src);









__declspec(dllimport)
int ecs_ptr_move_ctor(
    const ecs_world_t *world,
    ecs_entity_t type,
    void* dst,
    void *src);

















__declspec(dllimport)
void ecs_value_set(
    const ecs_world_t *world,
    ecs_value_t *v,
    ecs_entity_t type,
    const void *ptr);







__declspec(dllimport)
ecs_value_t ecs_value_new(
    const ecs_world_t *world,
    ecs_entity_t type);








__declspec(dllimport)
ecs_value_t ecs_value_init(
    const ecs_world_t *world,
    ecs_entity_t type,
    const void *ptr);







__declspec(dllimport)
void ecs_value_fini(
    const ecs_world_t *world,
    ecs_value_t *v);








__declspec(dllimport)
void ecs_value_copy(
    const ecs_world_t *world,
    ecs_value_t *dst,
    const ecs_value_t *src);








__declspec(dllimport)
void ecs_value_copy_ctor(
    const ecs_world_t *world,
    ecs_value_t *dst,
    const ecs_value_t *src);









__declspec(dllimport)
void ecs_value_move(
    const ecs_world_t *world,
    ecs_value_t *dst,
    ecs_value_t *src);








__declspec(dllimport)
void ecs_value_move_ctor(
    const ecs_world_t *world,
    ecs_value_t *dst,
    ecs_value_t *src);








__declspec(dllimport)
int ecs_value_compare(
    const ecs_world_t *world,
    const ecs_value_t *a,
    const ecs_value_t *b);








__declspec(dllimport)
_Bool ecs_value_equals(
    const ecs_world_t *world,
    const ecs_value_t *a,
    const ecs_value_t *b);














__declspec(dllimport)
int ecs_set_rtt_compare(
    ecs_world_t *world,
    ecs_entity_t type);














__declspec(dllimport)
int ecs_set_rtt_equals(
    ecs_world_t *world,
    ecs_entity_t type);




typedef struct ecs_primitive_desc_t {
    ecs_entity_t entity;       
    ecs_primitive_kind_t kind; 
} ecs_primitive_desc_t;







__declspec(dllimport)
ecs_entity_t ecs_primitive_init(
    ecs_world_t *world,
    const ecs_primitive_desc_t *desc);


typedef struct ecs_enum_desc_t {
    ecs_entity_t entity;       
    ecs_enum_constant_t constants[(32)]; 
    ecs_entity_t underlying_type; 
} ecs_enum_desc_t;







__declspec(dllimport)
ecs_entity_t ecs_enum_init(
    ecs_world_t *world,
    const ecs_enum_desc_t *desc);


typedef struct ecs_bitmask_desc_t {
    ecs_entity_t entity;       
    ecs_bitmask_constant_t constants[(32)]; 
} ecs_bitmask_desc_t;







__declspec(dllimport)
ecs_entity_t ecs_bitmask_init(
    ecs_world_t *world,
    const ecs_bitmask_desc_t *desc);


typedef struct ecs_array_desc_t {
    ecs_entity_t entity;  
    ecs_entity_t type;    
    int32_t count;        
} ecs_array_desc_t;







__declspec(dllimport)
ecs_entity_t ecs_array_init(
    ecs_world_t *world,
    const ecs_array_desc_t *desc);


typedef struct ecs_vector_desc_t {
    ecs_entity_t entity;  
    ecs_entity_t type;    
} ecs_vector_desc_t;







__declspec(dllimport)
ecs_entity_t ecs_vector_init(
    ecs_world_t *world,
    const ecs_vector_desc_t *desc);


typedef struct ecs_map_desc_t {
    ecs_entity_t entity;   
    ecs_entity_t key_type; 
    ecs_entity_t type;     
} ecs_map_desc_t;







__declspec(dllimport)
ecs_entity_t ecs_map_type_init(
    ecs_world_t *world,
    const ecs_map_desc_t *desc);


typedef struct ecs_struct_desc_t {
    ecs_entity_t entity; 
    ecs_member_t members[(32)]; 
    _Bool create_member_entities; 
} ecs_struct_desc_t;







__declspec(dllimport)
ecs_entity_t ecs_struct_init(
    ecs_world_t *world,
    const ecs_struct_desc_t *desc);









__declspec(dllimport)
int ecs_struct_add_member(
    ecs_world_t *world,
    ecs_entity_t type,
    const ecs_member_t *member);








__declspec(dllimport)
ecs_member_t* ecs_struct_get_member(
    ecs_world_t *world,
    ecs_entity_t type,
    const char *name);








__declspec(dllimport)
ecs_member_t* ecs_struct_get_nth_member(
    ecs_world_t *world,
    ecs_entity_t type,
    int32_t i);


typedef struct ecs_opaque_desc_t {
    ecs_entity_t entity;  
    EcsOpaque type;       
} ecs_opaque_desc_t;























__declspec(dllimport)
ecs_entity_t ecs_opaque_init(
    ecs_world_t *world,
    const ecs_opaque_desc_t *desc);


typedef struct ecs_unit_desc_t {
    
    ecs_entity_t entity;

    
    const char *symbol;

    
    ecs_entity_t quantity;

    
    ecs_entity_t base;

    
    ecs_entity_t over;

    
    ecs_unit_translation_t translation;

    





    ecs_entity_t prefix;
} ecs_unit_desc_t;







__declspec(dllimport)
ecs_entity_t ecs_unit_init(
    ecs_world_t *world,
    const ecs_unit_desc_t *desc);


typedef struct ecs_unit_prefix_desc_t {
    
    ecs_entity_t entity;

    
    const char *symbol;

    
    ecs_unit_translation_t translation;
} ecs_unit_prefix_desc_t;







__declspec(dllimport)
ecs_entity_t ecs_unit_prefix_init(
    ecs_world_t *world,
    const ecs_unit_prefix_desc_t *desc);







__declspec(dllimport)
ecs_entity_t ecs_quantity_init(
    ecs_world_t *world,
    const ecs_entity_desc_t *desc);























































__declspec(dllimport)
void FlecsMetaImport(
    ecs_world_t *world);





































































__declspec(dllimport)
int ecs_meta_from_desc(
    ecs_world_t *world,
    ecs_entity_t component,
    ecs_type_kind_t kind,
    const char *desc);











































































































































__declspec(dllimport)
void ecs_set_os_api_impl(void);





















































__declspec(dllimport)
ecs_entity_t ecs_import(
    ecs_world_t *world,
    ecs_module_action_t module,
    const char *module_name);









__declspec(dllimport)
ecs_entity_t ecs_import_c(
    ecs_world_t *world,
    ecs_module_action_t module,
    const char *module_name_c);




















__declspec(dllimport)
ecs_entity_t ecs_import_from_library(
    ecs_world_t *world,
    const char *library_name,
    const char *module_name);








__declspec(dllimport)
ecs_entity_t ecs_module_init(
    ecs_world_t *world,
    const char *c_name,
    const ecs_component_desc_t *desc);



















































































__declspec(dllimport)
char* ecs_cpp_get_type_name(
    char *type_name,
    const char *func_name,
    size_t len,
    size_t front_len);








__declspec(dllimport)
char* ecs_cpp_get_symbol_name(
    

    char *symbol_name,
    const char *type_name,
    
    size_t len);









__declspec(dllimport)
char* ecs_cpp_get_constant_name(
    char *constant_name,
    const char *func_name,
    size_t len,
    size_t back_len);







__declspec(dllimport)
const char* ecs_cpp_trim_module(
    ecs_world_t *world,
    const char *type_name);

typedef void (*ecs_cpp_type_action_t)(
    ecs_world_t *world,
    ecs_entity_t component);

typedef struct ecs_cpp_component_desc_t {
    ecs_entity_t id;

    int32_t ids_index;



    const char *name;
    const char *cpp_name;
    const char *cpp_symbol;
    size_t size;
    size_t alignment;
    ecs_cpp_type_action_t lifecycle_action;
    ecs_cpp_type_action_t enum_action;
    _Bool is_component;
    _Bool explicit_registration;
} ecs_cpp_component_desc_t;






__declspec(dllimport)
ecs_entity_t ecs_cpp_component_register(
    ecs_world_t *world,
    const ecs_cpp_component_desc_t *desc);







__declspec(dllimport)
void ecs_cpp_enum_init(
    ecs_world_t *world,
    ecs_entity_t id,
    ecs_entity_t underlying_type);












__declspec(dllimport)
ecs_entity_t ecs_cpp_enum_constant_register(
    ecs_world_t *world,
    ecs_entity_t parent,
    ecs_entity_t id,
    const char *name,
    void *value,
    ecs_entity_t value_type,
    size_t value_size);


typedef struct ecs_cpp_get_mut_t {
    ecs_world_t *world;       
    ecs_stage_t *stage;       
    void *ptr;                
    _Bool call_modified;       
} ecs_cpp_get_mut_t;










__declspec(dllimport)
 ecs_cpp_get_mut_t ecs_cpp_set(
    ecs_world_t *world,
    ecs_entity_t entity,
    ecs_id_t component,
    const void *new_ptr,
    size_t size);










__declspec(dllimport)
 ecs_cpp_get_mut_t ecs_cpp_assign(
    ecs_world_t *world,
    ecs_entity_t entity,
    ecs_id_t component,
    const void *new_ptr,
    size_t size);










__declspec(dllimport)
 ecs_entity_t ecs_cpp_new(
    ecs_world_t *world,
    ecs_entity_t parent,
    const char *name,
    const char *sep,
    const char *root_sep);








__declspec(dllimport)
ecs_member_t* ecs_cpp_last_member(
    const ecs_world_t *world,
    ecs_entity_t type);










































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































































