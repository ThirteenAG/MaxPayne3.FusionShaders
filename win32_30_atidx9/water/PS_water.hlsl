sampler2D DepthBufferSampler : register(s3);
sampler2D ReflectTextureSampler : register(s2);
sampler2D SurfaceTextureSampler : register(s1);
float4 globalScalars : register(c35);
float4 viewProj : register(c98);
float4 waterColour : register(c90);
float waterIntensity : register(c91);
float waterReflectionScale : register(c96);

struct PS_IN
{
	float3 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float3 texcoord2 : TEXCOORD2;
	float3 texcoord3 : TEXCOORD3;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float4 r2;
	r0 = float4(0.002, 0.002, 0.01, 0.01) * i.texcoord2.xyxy;
	r1 = tex2D(SurfaceTextureSampler, r0.xy);
	r0 = tex2D(SurfaceTextureSampler, r0.zw);
	r0.xy = r0.zw + -0.5;
	r0.zw = r1.zw + -0.5;
	r0.zw = r0.zw * 0.0512;
	r1.xyz = i.texcoord2.xyz;
	r1.xyz = r1.xyz + -i.texcoord3.xyz;
	r1.w = dot(r1.xyz, r1.xyz);
	r1.xyz = r1.xyz + 1E-05;
	r2.xyz = normalize(r1.xyz);
	r1.x = r1.w * -0.0004 + 1;
	r2.w = max(r1.x, 0);
	r1.x = -r2.w + 1;
	r0.zw = r0.zw * r1.xx;
	r1.x = 1 / i.texcoord1.z;
	r1.x = r1.x * r2.w;
	r0.zw = i.texcoord1.xy * r1.xx + r0.zw;
	r0.xy = r0.xy * 0.256 + r0.zw;
	r0.xy = r0.xy + 1E-05;
	r0.z = 1.00001;
	r1.xyz = normalize(r0.xyz);
	r0.xyz = r2.xyz * float3(1, 1, 0) + 1E-05;
	r0.w = dot(r2.xyz, r1.xyz);
	r0.z = dot(r0.xyz, r0.xyz);
	r0.z = rsqrt(r0.z);
	r2.xy = r0.zz * r0.xy;
	r2.zw = float2(1, -1);
	r1 = r1.xyyx * r2.yyxz;
	r0.xy = r1.zw * r2.wx + r1.xy;
	r0.z = 0.03 * i.texcoord.z;
	r0.z = 1 / r0.z;
	r0.z = r0.z * 0.5;
	r1.x = 1 / i.texcoord.z;
	r1.xyz = r1.xxx * i.texcoord.xyx;
	r1.xyz = r1.xyz * float3(-0.5, -0.5, 0.5) + 0.5;
	r2.xy = r0.xy * r0.zz + r1.xy;
	r1 = tex2D(DepthBufferSampler, r1.zy);
	r2.zw = 0;
	r2 = tex2Dlod(ReflectTextureSampler, r2);
	r0.xyz = r2.xyz * waterReflectionScale.xxx;
	r0.xyz = r0.xyz * r0.xyz;
	r0.xyz = r0.xyz * 16;
	r1.y = -viewProj.x + viewProj.y;
	r1.y = 1 / r1.y;
	r1.x = viewProj.y * -r1.y + r1.x;
	r1.y = r1.y * viewProj.y;
	r1.y = r1.y * viewProj.x;
	r1.x = 1 / r1.x;
	r1.x = -r1.y * r1.x + -i.texcoord.z;
	r1.y = r1.x * waterColour.w;
	r1.y = abs(r1.y) + 1E-05;
	r2.x = pow(r1.y, 0.25001);
	r1.y = saturate(r2.x + 0.125);
	r1.x = (r1.x >= 0) ? r1.y : 0.18122765;
	r1.y = 1 / r1.x;
	r0.xyz = r0.xyz * r1.yyy;
	r1.y = r0.w + 1;
	r1.y = abs(r1.y) + 1E-05;
	r2.x = pow(r1.y, 5.00001);
	r1.y = r2.x * 0.6 + 0.2;
	r0.w = (-r0.w >= 0) ? r1.y : 0.80003;
	r0.w = r1.x * r0.w;
	o.w = r1.x;
	r0.w = r0.w * 0.5;
	r0.xyz = r0.xyz * r0.www;
	r1.xyz = waterColour.xyz;
	r0.xyz = r1.xyz * waterIntensity.xxx + r0.xyz;
	o.xyz = r0.xyz * globalScalars.yyy;

	return o;
}
