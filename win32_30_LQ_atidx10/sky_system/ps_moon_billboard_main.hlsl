float3 lunarCycle : register(c163);
float3 moonColor : register(c164);
float moonIntensity : register(c162);
sampler2D moonSampler : register(s5);
float3 zenithConstants : register(c136);

struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
};

half4 main(PS_IN i) : COLOR
{
	half4 o;

	float4 r0;
	float4 r1;
	float3 r2;
	r0.xy = -0.5 + i.texcoord.xy;
	r0.xy = r0.xy + r0.xy;
	r0.x = dot(r0.xy, -r0.xy) + 1;
	r1.x = max(r0.x, 0);
	r0.x = rsqrt(r1.x);
	r0.y = 1 / r0.x;
	r0.xz = i.texcoord.xy * 2 + -1;
	r0.xyz = r0.xyz + 1E-05;
	r1.xyz = normalize(r0.xyz);
	r0.x = 1E-05;
	r0.xyz = r0.xxx + lunarCycle.xyz;
	r2 = normalize(r0.xyz);
	r0.x = dot(r1.xyz, r2.xyz);
	r1 = half4(tex2D(moonSampler, i.texcoord.xy));
	r0.yzw = r1.xyz * moonColor.xyz;
	r0.yzw = r0.xxx * r0.yzw;
	r0.yzw = r1.www * r0.yzw;
	r0.yzw = r0.yzw * moonIntensity.xxx;
	r1.xyz = 1E-05 + i.texcoord1.xyz;
	r1.x = dot(r1.xyz, r1.xyz);
	r1.x = rsqrt(r1.x);
	r1.x = saturate(r1.x * r1.z);
	r1.y = 1 / zenithConstants.x;
	r1.x = saturate(dot(r1.xx, r1.yy) + 0);
	r0.yzw = half3(r0.yzw * r1.xxx);
	o.xyz = (r0.xxx >= 0) ? r0.yzw : 0;
	o.w = 1;

	return o;
}
