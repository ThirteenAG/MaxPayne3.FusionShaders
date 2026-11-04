float4 ColorCorrectBottomOffset : register(c44);
float4 ColorCorrectBottomOffsetScreenEdge : register(c67);
float4 ColorCorrectTopAndPedReflectScale : register(c43);
float4 ColorCorrectTopScreenEdge : register(c66);
float4 ColorShift : register(c45);
sampler2D DiffuseSampler : register(s1);
float4 deSatContrastGamma : register(c46);
float4 gAdrenoFXVars : register(c68);
float4 globalScalars4 : register(c51);
float4 globalScreenSize : register(c41);

struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float2 vpos : VPOS;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	float3 r4;
	r0 = ColorCorrectTopScreenEdge;
	r0.w = r0.w + -ColorCorrectBottomOffsetScreenEdge.w;
	r0.w = (r0.w >= 0) ? -r0.w : -0;
	r1.x = r0.w + ColorCorrectTopScreenEdge.w;
	r1.x = 1 / r1.x;
	r1.y = 1 / globalScreenSize.x;
	r2.x = r1.y * i.vpos.x;
	r1.y = 1 / globalScreenSize.y;
	r2.y = r1.y * i.vpos.y;
	r1.yz = r2.xy + -0.5;
	r1.y = dot(r1.yz, r1.yz) + 0;
	r1.y = rsqrt(r1.y);
	r1.y = 1 / r1.y;
	r0.w = r0.w + r1.y;
	r1.x = saturate(r1.x * r0.w);
	r0.w = (r0.w >= 0) ? r1.x : 0;
	r1.x = gAdrenoFXVars.x;
	r1.x = r1.x * deSatContrastGamma.x;
	r3 = tex2D(DiffuseSampler, i.texcoord.xy);
	r1.yzw = r3.xyz * i.texcoord1.xyz;
	r1.y = dot(r1.yzw, float3(0.2125, 0.7154, 0.0721));
	r2.xzw = r3.xyz * i.texcoord1.xyz + -r1.yyy;
	r1.xzw = r1.xxx * r2.xzw + r1.yyy;
	r2.x = r1.y * ColorCorrectBottomOffset.w;
	r1.y = r1.y * ColorShift.w;
	r3.xyz = globalScalars4.yzw * -r2.xxx + r1.xzw;
	r1.xzw = ColorShift.xyz * -r1.yyy + r1.xzw;
	r4 = r2.xxx * globalScalars4.yzw;
	r2.x = saturate(r2.x);
	r2.xzw = r2.xxx * r3.xyz + r4.xyz;
	r0.xyz = r2.yyy * ColorCorrectBottomOffsetScreenEdge.xyz + r0.xyz;
	r3.xyz = ColorCorrectBottomOffset.xyz;
	r3.xyz = r2.yyy * r3.xyz + ColorCorrectTopAndPedReflectScale.xyz;
	r2.xyz = r0.xyz * r2.xzw;
	r0.xyz = r1.yyy * ColorShift.xyz;
	r1.y = saturate(r1.y);
	r0.xyz = r1.yyy * r1.xzw + r0.xyz;
	r1.xyz = r3.xyz * r0.xyz;
	r2.w = 1;
	r1.w = 1;
	r3 = lerp(r1, r2, r0.w);
	o = (ColorCorrectTopScreenEdge.w >= 0) ? r3 : r1;

	return o;
}
